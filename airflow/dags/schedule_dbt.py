# The DAG object; we'll need this to instantiate a DAG
from airflow import DAG, macros
# Operators; we need this to operate!
from airflow.operators.bash_operator import BashOperator
# from airflow.operators.python_operator import PythonOperator
from airflow.utils.dates import days_ago

# Parse nodes
import json
JSON_MANIFEST_DBT = '/project/dbt/target/manifest.json'
PARENT_MAP = 'parent_map'


def sanitise_node_names(value):
        segments = value.split('.')
        if segments[0] == 'model':
                return value.split('.')[-1]

def get_node_structure():
    with open(JSON_MANIFEST_DBT) as json_data:
        data = json.load(json_data)

    ancestors_data = data[PARENT_MAP]

    tree = {}

    for node in ancestors_data:
            
            ancestors = list(set(ancestors_data[node]))

            ancestors_2 = [sanitise_node_names(ancestor) for ancestor in ancestors]
            
            clean_node_name = sanitise_node_names(node)
            if clean_node_name is not None:
                    tree[clean_node_name] = ancestors_2
    
    return tree


# [START default_args]
# These args will get passed on to each operator
# You can override them on a per-task basis during operator initialization
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': days_ago(5),
    'email': ['airflow@example.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    # 'retry_delay': timedelta(minutes=5),
    # 'queue': 'bash_queue',
    # 'pool': 'backfill',
    # 'priority_weight': 10,
    # 'end_date': datetime(2016, 1, 1),
    # 'wait_for_downstream': False,
    # 'dag': dag,
    # 'sla': timedelta(hours=2),
    # 'execution_timeout': timedelta(seconds=300),
    # 'on_failure_callback': some_function,
    # 'on_success_callback': some_other_function,
    # 'on_retry_callback': another_function,
    # 'sla_miss_callback': yet_another_function,
    # 'trigger_rule': 'all_success'
}
# [END default_args]

# [START instantiate_dag]

dag = DAG(
    'daily_dbt_models',
    default_args=default_args,
    description='Managing dbt data pipeline',
    schedule_interval = '@daily',
)
# [END instantiate_dag]

nodes = get_node_structure()
operators = {}
for node in nodes:
    # date = """{{ macros.ds_format(ts_nodash, "%Y%m%dT%H%M%S", "%Y-%m-%d-%H-%M") }}"""
    date_end = "{{ ds }}"
    date_start = "{{ yesterday_ds }}"
    # print('MACRO : {}'.format(date))
    # bsh_cmd = 'cd /project/dbt && dbt run --models {nodeName} --vars \'"start_date":"2020-02-15 15:00:00 UTC", "end_date":"2020-02-15 15:20:00 UTC"}}\' --full-refresh'.format(nodeName = node, date_start = date_start, date_end = date_end)
    bsh_cmd = 'cd /project/dbt && dbt run --models {nodeName} --vars \'{{"start_date":"{start_date}", "end_date":"{end_date}"}}\' '.format(nodeName = node, start_date = date_start, end_date = date_end)
    tmp_operator = BashOperator(
        task_id= node,
        bash_command=bsh_cmd,
        dag=dag,
    )
    operators[node] = tmp_operator

for node in nodes:
    for parent in nodes[node]:
        operators[node] << operators[parent]

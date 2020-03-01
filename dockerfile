FROM python:3.7

RUN export AIRFLOW_HOME=/user/airflow

RUN pip install dbt==0.15.2 \
    && pip install apache-airflow

RUN mkdir /project
COPY scripts/ /project/scripts/
COPY misc/ /project/misc/
COPY airflow/ /project/airflow/

EXPOSE 8080

RUN chmod +x /project/scripts/init.sh
ENTRYPOINT [ "/project/scripts/init.sh" ]
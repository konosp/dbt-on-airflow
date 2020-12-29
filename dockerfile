FROM python:3.7

RUN pip install dbt==0.15.0 \
    && pip install 'apache-airflow==1.10.14'

RUN mkdir /project
COPY scripts/ /project/scripts/
COPY misc/ /project/misc/
COPY airflow/ /project/airflow/

EXPOSE 8080
RUN export AIRFLOW_HOME=/user/airflow

RUN chmod +x /project/scripts/init.sh
ENTRYPOINT [ "/project/scripts/init.sh" ]
#!/usr/bin/env bash

export DBT_PROJECT_PATH=/project

git clone https://github.com/konosp/adobe-clickstream-dbt.git \
    && mkdir /project/dbt \
    && mv adobe-clickstream-dbt/* /project/dbt/

mkdir /root/.dbt \
    && cp $DBT_PROJECT_PATH/misc/profile-demo.yml /root/.dbt/profiles.yml \
    && cd $DBT_PROJECT_PATH/dbt \
    && dbt compile

mkdir /root/airflow \
    && cp $DBT_PROJECT_PATH/airflow/airflow.cfg /root/airflow/ \
    && mkdir /root/airflow/dags \
    && cp $DBT_PROJECT_PATH/airflow/dags/* /root/airflow/dags/ \
    && airflow initdb \
    && airflow scheduler & airflow webserver
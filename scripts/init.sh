#!/usr/bin/env bash

export DBT_PROJECT_PATH=/project

mkdir /root/.dbt \
    && cp $DBT_PROJECT_PATH/misc/profile-demo.yml /root/.dbt/profiles.yml \
    && cd $DBT_PROJECT_PATH/dbt \
    && dbt compile

#
airflow initdb &&
    ## cp $DBT_PROJECT_PATH/airflow/airflow.cfg /root/airflow/ &&
    mkdir /root/airflow/dags &&
    cp $DBT_PROJECT_PATH/airflow/dags/* /root/airflow/dags/ \
    && airflow scheduler \
    & airflow webserver
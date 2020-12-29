#!/usr/bin/env bash

export DBT_PROJECT_PATH=/project

AIRFLOW__WEBSERVER__SECRET_KEY="openssl rand -hex 30"
export AIRFLOW__WEBSERVER__SECRET_KEY

if [[ "$1" != "" ]]; then
    GITREPO="$1"
elif [[ "$1" = "" ]]; then
    echo "Need dbt project URL. Exiting.."
    exit;
fi

mkdir /tmpdata \
    && cd /tmpdata \
    && git clone $GITREPO

folders=*/; 

mkdir /project/dbt \
    && mv ${folders[0]}/* /project/dbt/ \
    && rm -rf /tmpdata

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
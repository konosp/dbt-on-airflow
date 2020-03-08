# dbt on Airflow
Experimental project on managing dbt models on Apache Airflow.

## Requirements
There two sample files in the misc/ folder; profile-demo_sample.yml and service_account_key_sample.json. There files are needed for the dbt/BigQuery configuration and for the BigQuery service account that runs within the docker container.

The files need to be renamed so that "_sample" is removed. For example:
- profile-demo_sample.yml -> profile-demo.yml
- service_account_key_sample.json -> service_account_key.json

Then as part of the dockefile command below, the files are utilised:
```
COPY misc/ /project/misc/
```

### BigQuery permissions
In order for the Google Cloud service account to be able to run the jobs, the following permissions are needed:
- BigQuery Data Editor
- BigQuery Job User
- BigQuery User

## How to run
Build your docker image and use 'dbt-airflow' as image name
```
docker build -t dbt-airflow .
```
Run the Docker container, expose port 8080 and pass as an argument the dbt project url: 
```
docker run -it --rm -p 8080:8080 dbt-airflow https://github.com/konosp/adobe-clickstream-dbt.git
```

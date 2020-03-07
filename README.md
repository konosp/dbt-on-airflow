# dbt on Airflow
Experimental project on managing dbt models on Apache Airflow.

## Requirements


## How to run
Build your docker image and use 'dbt-airflow' as image name
```
docker build -t dbt-airflow .
```
Run the Docker container, expose port 8080 and pass as an argument the dbt project url: 
```
docker run -it --rm -p 8080:8080 dbt-airflow https://github.com/konosp/adobe-clickstream-dbt.git
```

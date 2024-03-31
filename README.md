There was an attempt at
# Aligulac (Starcraft 2 matches) Analytics

Hello friends and family and other creatures of the sea.  
This is an end-to-end analytics pipeline for starcraft 2 matches using the Aligulac dataset from [Aligulac](http://www.aligulac.com).

The pipeline comprises of multiple parts - most notably are: 
- PostgreSQL to restore the Aligulac database locally (inside a docker container with Mage.AI)
- [Mage.AI](https://www.mage.ai) as the primary orchestrator and secondary data-transformation tool
- [dbt](https://www.dbt.com) (Mage-flavoured) as the primary data transformation tool running inside Mage.
- Terraformq as the IaC tool to manage cloud resources in GCP

Google Cloud Provider is the primary cloud resource being used (for now):
- BigQuery as the Data Warehouse solution with Raw, Bronze, Silver and Gold stages
- Cloud Storage bucket as the Data Lake to store various Parquet files and table
- and, Data Studio as the dashboarding tool

## Installation

#### .ENV file

Copy and rename the supplied dev.env file to .env

Modify the content of the file if required (default setting listed below)
```
PROJECT_NAME=aligulac_analytics
POSTGRES_DB=aligulac_db
POSTGRES_USER=admin
POSTGRES_PASSWORD=aligulacdb
POSTGRES_HOST=postgres_aligulac
PG_HOST_PORT=5432
```

#### Google Cloud Platform

Create Service account(s) for Mage and Terraform.

For both Service Accounts the below roles were used
- Cloud Storage Admin
- BigQuery Admin

Export the keys as .JSON and drop them into their respective locations in

``` 
# for the Mage and dbt,
# next to the mage-dbt_key_location.txt placeholder
keys/

# for Terraform,
# next to the terraform_key_location.txt placeholder
terraform/keys/ 
```

variable "credentials" {
  description = "GCP JSON Key path"
  default     = "./keys/gcp_key.json"
}
variable "project" {
  description = "Project ID"
  default     = "aligulac-dezc"
}
variable "region" {
  description = "Project Region"
  default     = "us-central1"
}
variable "location" {
  description = "Project Location"
  default     = "US"
}
variable "bq_raw_dataset_name" {
  description = "Raw - dataset name"
  default     = "raw"
}
variable "bq_bronze_dataset_name" {
  description = "Bronze - dataset name"
  default     = "bronze"
}
variable "bq_silver_dataset_name" {
  description = "Silver - dataset name"
  default     = "silver"
}
variable "bq_gold_dataset_name" {
  description = "Gold - dataset name"
  default     = "gold"
}
variable "gcs_datalake_name" {
  description = "Datalake name"
  default     = "aligulac_datalake"
}
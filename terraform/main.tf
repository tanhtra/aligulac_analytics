terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.13.0"
    }
  }
}

provider "google" {
  # Configuration options
  credentials = file(var.credentials)
  project     = var.project
  region      = var.region
}

resource "google_storage_bucket" "data_lake" {
  name          = var.gcs_datalake_name
  location      = var.location
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

resource "google_bigquery_dataset" "raw" {
  dataset_id = var.bq_raw_dataset_name
  location   = var.location
}
resource "google_bigquery_dataset" "bronze" {
  dataset_id = var.bq_bronze_dataset_name
  location   = var.location
}
resource "google_bigquery_dataset" "silver" {
  dataset_id = var.bq_silver_dataset_name
  location   = var.location
}
resource "google_bigquery_dataset" "gold" {
  dataset_id = var.bq_gold_dataset_name
  location   = var.location
}
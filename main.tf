
terraform {
  # The modules used in this example require Terraform 0.12, additionally we depend on a bug fixed in version 0.12.7.
  required_version = ">= 0.12.7"
}


resource "google_storage_bucket" "my_bucket" {
name     = var.bucket_name
location = var.region
}

variable "project_id" {
description = "Google Project ID."
type        = string
default     = "spanner33"
}

variable "bucket_name" {
description = "GCS Bucket name. Value should be unique ."
type        = string
default     = "github"
}

variable "region" {
description = "Google Cloud region"
type        = string
default     = "europe-west2"
}
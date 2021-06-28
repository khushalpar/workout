



resource "google_storage_bucket" "my_bucket" {
project  = "spanner33"    
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
default     = "githubspanner333"
}

variable "region" {
description = "Google Cloud region"
type        = string
default     = "us-central1"
}

/////////////////////
resource "google_compute_instance" "vm_instance" {
 project  = "spanner33"
  name         = "poc-instance"
  machine_type = "f1-micro"
  zone   = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "default"
    access_config {
    }
  }
}


terraform {
  # The modules used in this example require Terraform 0.12, additionally we depend on a bug fixed in version 0.12.7.
  required_version = ">= 0.12.7"
  backend "gcs" {
    bucket  = "githubspanner33"
    prefix  = "terraform/state"
    credentials = "spanner33-33b118fd26d6.json"
  }
}


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
default     = "githubspanner33"
}

variable "region" {
description = "Google Cloud region"
type        = string
default     = "europe-west2"
}

/////////////////////

resource "google_service_account" "default" {
  project  = "spanner33" 
  account_id   = "service-account-id"
  display_name = "Service Account"
}

resource "google_compute_instance_template" "default" {
  project  = "spanner33" 
  name        = "appserver-template"
  description = "This template is used to create app server instances."

  tags = ["foo", "bar"]

  labels = {
    environment = "dev"
  }

  instance_description = "description assigned to instances"
  machine_type         = "e2-medium"
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  // Create a new boot disk from an image
  disk {
    source_image      = "debian-cloud/debian-9"
    auto_delete       = true
    boot              = true
    // backup the disk every day
    resource_policies = [google_compute_resource_policy.daily_backup.id]
  }

  // Use an existing disk resource
  disk {
    // Instance Templates reference disks by name, not self link
    source      = google_compute_disk.foobar.name
    auto_delete = false
    boot        = false
  }

  network_interface {
    network = "default"
  }

  metadata = {
    foo = "bar"
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}

data "google_compute_image" "my_image" {
  family  = "debian-9"
  project = "debian-cloud" 
}

resource "google_compute_disk" "foobar" {
  project  = "spanner33" 
  name  = "existing-disk"
  image = data.google_compute_image.my_image.self_link
  size  = 11
  type  = "pd-ssd"
  zone  = "us-central1-a"
}

resource "google_compute_resource_policy" "daily_backup" {
  project  = "spanner33" 
  name   = "every-day-4am"
  region = "us-central1"
  snapshot_schedule_policy {
    schedule {
      daily_schedule {
        days_in_cycle = 1
        start_time    = "04:00"
      }
    }
  }
}

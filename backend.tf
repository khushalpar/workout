terraform {
  # The modules used in this example require Terraform 0.12, additionally we depend on a bug fixed in version 0.12.7.
  required_version = ">= 0.12.7"
  backend "gcs" {
    bucket  = "githubspanner33"
    prefix  = "terraform/state"
    credentials = "spanner33-33b118fd26d6.json"
  }
}
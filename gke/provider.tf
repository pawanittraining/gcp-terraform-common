provider "google" {
  project = var.project_id
  region  = var.region
}

terraform {
  backend "gcs" {
    bucket  = "terraform-state-bucket-web-app"
    prefix  = "gke"
  }
}

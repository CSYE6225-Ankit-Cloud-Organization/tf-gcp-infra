# Configure Google Cloud provider
provider "google" {
  project = var.project_id
  region  = var.region
}

terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
  }
}

provider "random" {
}

provider "google-beta" {
  region  = var.region
  zone    = var.instance_zone
  project = var.project_id
}
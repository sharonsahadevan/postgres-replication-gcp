provider "google" {
  credentials = file("../gcp-credential.json")
  project     = "toggle-pgsql"
  region      = "us-central1"
  zone        = "us-central1-a"
}

terraform {
  backend "gcs" {
    bucket      = "toggle-terraform-state-bucket"
    prefix      = "terraform/state"
    credentials = "../gcp-credential.json"
  }
}

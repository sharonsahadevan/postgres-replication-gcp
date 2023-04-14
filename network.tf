resource "google_compute_network" "vpc" {
  name                    = "toggle-vpc"
  auto_create_subnetworks = "false"
  project                 = "toggle-pgsql"
}

resource "google_compute_subnetwork" "subnet_a" {
  name          = "toggl-subnet-a"
  ip_cidr_range = "10.0.0.0/16"
  network       = google_compute_network.vpc.self_link
  region        = "us-central1"
}

resource "google_compute_subnetwork" "subnet_b" {
  name          = "toggle-subnet-b"
  ip_cidr_range = "10.1.0.0/16"
  network       = google_compute_network.vpc.self_link
  region        = "us-central1"
}

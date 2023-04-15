resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = var.auto_create_subnetworks
  project                 = var.project_id
}

resource "google_compute_subnetwork" "subnet_a" {
  name          = "toggl-subnet-a"
  ip_cidr_range = var.ip_cidr_range_subnet_a
  network       = google_compute_network.vpc.self_link
  region        = var.region
}

resource "google_compute_subnetwork" "subnet_b" {
  name          = "toggle-subnet-b"
  ip_cidr_range = var.ip_cidr_range_subnet_b
  network       = google_compute_network.vpc.self_link
  region        = var.region
}

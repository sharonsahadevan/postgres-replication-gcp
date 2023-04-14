resource "google_compute_instance" "postgresql" {
  name         = "postgresql-master"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  labels = {
    name = "postgresql-master"
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network    = google_compute_network.vpc.self_link
    subnetwork = google_compute_subnetwork.subnet_a.self_link
    access_config {}
  }

  metadata_startup_script = <<EOF
#!/bin/bash
sudo apt-get update

# Add PostgreSQL repository and import the repository signing key
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

# Update package lists and install PostgreSQL 13
sudo apt-get update
sudo apt-get install -y postgresql-13

# Configure PostgreSQL 13
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/13/main/postgresql.conf
#sudo sh -c 'echo "host all all 0.0.0.0/0 md5" >> /etc/postgresql/13/main/pg_hba.conf'
sudo sh -c 'echo "host all all 10.0.0.0/16 trust" >> /etc/postgresql/13/main/pg_hba.conf'
sudo sh -c 'echo "host replication all 10.0.0.0/16 trust" >> /etc/postgresql/13/main/pg_hba.conf'
#sudo sh -c 'echo "host replication all 0.0.0.0/0 md5" >> /etc/postgresql/13/main/pg_hba.conf'
sudo sed -i "s/#wal_level = replica/wal_level = replica/" /etc/postgresql/13/main/postgresql.conf
sudo sed -i "s/#max_wal_senders = 10/max_wal_senders = 5/" /etc/postgresql/13/main/postgresql.conf
sudo sed -i "s/#wal_keep_segments = 0/wal_keep_segments = 32/" /etc/postgresql/13/main/postgresql.conf

# Restart PostgreSQL 13
sudo systemctl restart postgresql
EOF


  tags = ["allow-postgres-master", "allow-ssh"]

}


resource "google_compute_firewall" "allow_postgres" {
  name    = "allow-postgres-master"
  network = google_compute_network.vpc.self_link

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-postgres-master"]
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-ssh"]
}

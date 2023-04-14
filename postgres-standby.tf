resource "google_compute_instance" "postgresql-standby" {
  name         = "postgresql-standby"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network    = google_compute_network.vpc.self_link
    subnetwork = google_compute_subnetwork.subnet_b.self_link
    access_config {}
  }

  metadata_startup_script = <<-EOF
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
sudo sh -c 'echo "host all all 10.0.0.0/16 trust" >> /etc/postgresql/13/main/pg_hba.conf'
sudo sh -c 'echo "host replication all 10.0.0.0/16 trust" >> /etc/postgresql/13/main/pg_hba.conf'
sudo systemctl restart postgresql

# Perform base backup from the master instance
sudo -u postgres pg_basebackup -h <MASTER_IP> -D /var/lib/postgresql/13/main -U replicator -v -P --wal-method=stream
sudo cp /etc/postgresql/13/main/postgresql.conf /etc/postgresql/13/main/postgresql.conf.bak
sudo sh -c 'echo "standby_mode = on" >> /etc/postgresql/13/main/postgresql.conf'
sudo sh -c 'echo "primary_conninfo = 'host=<MASTER_IP> port=5432 user=replicator application_name=postgresql-standby'" >> /etc/postgresql/13/main/postgresql.conf'
sudo sh -c 'echo "trigger_file = '/tmp/postgresql.trigger'" >> /etc/postgresql/13/main/postgresql.conf'

# Restart PostgreSQL 13
sudo systemctl restart postgresql
EOF



  tags = ["allow-postgresql-standby", "allow-ssh-standby"]

}

resource "google_compute_firewall" "postgresql-standby" {
  name    = "postgresql-standby"
  network = google_compute_network.vpc.self_link

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-postgresql-standby"]
}

resource "google_compute_firewall" "allow_ssh_standby" {
  name    = "allow-ssh-standby"
  network = google_compute_network.vpc.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-ssh-standby"]
}

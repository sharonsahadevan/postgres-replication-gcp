
# General

variable "project_id" {
  default = "toggl-pgsql"
}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-a"
}

# cloud storage
variable "backup_bucket_name" {
  default     = "toggl-postgres-backup-bucket"
  description = "backup storage bucket"
  type        = string
}

variable "backup_rention_period" {
  default = 15
}

# network

variable "vpc_name" {
  default = "toggle-vpc"
}

variable "auto_create_subnetworks" {
  default = "false"
}

variable "toggle-pgsql" {
  default = "toggle-pgsql"
}

variable "ip_cidr_range_subnet_a" {
  default = "10.0.0.0/16"
}

variable "ip_cidr_range_subnet_b" {
  default = "10.1.0.0/16"
}


# Postgres 

variable "master_instance_type"{
  default = "e2-micro"
}

variable "standby_instance_type"{
  default = "e2-micro"
}

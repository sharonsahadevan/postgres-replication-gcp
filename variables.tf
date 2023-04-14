variable "backup_rention_period" {
  default = 15
}

variable "region" {
  default = "us-central1"
}

variable "toggl-postgres-backup-bucket" {
  default     = "toggl-postgres-backup-bucket"
  description = "backup storage bucket"
  type        = string
}

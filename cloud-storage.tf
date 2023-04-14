resource "google_storage_bucket" "postgres_backup_bucket" {
  name     = "toggl-postgres-backup-bucket"
  location = "us-central1"

  // 15 days retention period. 

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = "15"
    }
  }

}

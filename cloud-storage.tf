resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "google_storage_bucket" "postgres_backup_bucket" {
  name     = "${var.backup_bucket_name}_${random_id.bucket_suffix.hex}"
  location = var.region

  // 15 days retention period. 

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = var.backup_rention_period
    }
  }

}

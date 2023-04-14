resource "google_monitoring_alert_policy" "high_disk_usage" {
  display_name = "High Usage Alert - Primary Database"
  combiner     = "OR"

  conditions {
    display_name = "CPU Usage > 90%"
    condition_threshold {
      filter          = "metric.type=\"compute.googleapis.com/instance/cpu/usage_time\" AND resource.type=\"gce_instance\" AND metric.label.instance_name=\"postgresql-master\""
      comparison      = "COMPARISON_GT"
      duration        = "60s"
      threshold_value = 0.9

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
        group_by_fields    = ["resource.labels.instance_id"]
      }
    }
  }

  conditions {
    display_name = "Disk Write Usage > 85%"
    condition_threshold {
      filter          = "metric.type=\"compute.googleapis.com/instance/disk/write_bytes_count\" AND resource.type=\"gce_instance\" AND metric.label.instance_name=\"postgresql-master\""
      comparison      = "COMPARISON_GT"
      duration        = "60s"
      threshold_value = 0.85

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
        group_by_fields    = ["resource.labels.instance_id"]
      }
    }
  }
}

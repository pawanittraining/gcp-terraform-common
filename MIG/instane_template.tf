data "google_compute_image" "web_app_image" {
  name    = var.instance_template_image
  project = var.project_id
}


resource "google_compute_instance_template" "instance_template" {
  name        = "web-template-${var.environment}-${var.template_name}"
  description = "This template is used to create app server instances."
  tags = var.tags
  labels = var.common_labels
  instance_description = "web server to serve traffic from internet user"
  machine_type         = var.machine_type
  can_ip_forward       = false
  
  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  // Create a new boot disk from an image
  disk {
    source_image      = google_compute_image.web_app_image.self_link
    auto_delete       = true
    boot              = true
    // backup the disk every day
    resource_policies = [google_compute_resource_policy.daily_backup.id]
  }
  network_interface {
    network = var.vpc_name
  }
  metadata_startup_script = file("files/apache.sh")
}
resource "google_compute_resource_policy" "daily_backup" {
  name   = "every-day-4am"
  region = "us-central1"
  snapshot_schedule_policy {
    schedule {
      daily_schedule {
        days_in_cycle = 1
        start_time    = "04:00"
      }
    }
  }
}


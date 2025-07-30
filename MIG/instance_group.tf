# Health Check for MIG
resource "google_compute_health_check" "web_app" {
  name               = "web-app-http-health-check-${var.environment}"
  check_interval_sec = 10
  timeout_sec        = 5
  healthy_threshold  = 2
  unhealthy_threshold = 3

  http_health_check {
    port = 80
  }
}

# Managed Instance Group
resource "google_compute_region_instance_group_manager" "web_app_group" {
  name               = "web-app-group-${var.environment}"
  base_instance_name = "web-instance"
  region             = var.region
  target_size        = var.instance_count
  description        = "Managed Instance Group for web application in ${var.environment} environment"

  version {
    instance_template = google_compute_instance_template.instance_template.self_link
  }

  named_port {
    name = "http"
    port = 80
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.web_app.self_link
    initial_delay_sec = 60
  }

  depends_on = [google_compute_instance_template.instance_template]
}

# Autoscaler
resource "google_compute_region_autoscaler" "web_app_autoscaler" {
  name   = "web-app-autoscaler-${var.environment}"
  region = var.region
  target = google_compute_region_instance_group_manager.web_app_group.id

  autoscaling_policy {
    max_replicas    = 2
    min_replicas    = 1
    cooldown_period = 60

    cpu_utilization {
      target = 0.3
    }
  }
}

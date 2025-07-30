# Reserve a global IP address
resource "google_compute_global_address" "web_lb_ip" {
  name = "web-lb-ip-${var.environment}"
}

# Backend Service to connect Load Balancer to MIG
resource "google_compute_backend_service" "web_backend" {
  name                  = "web-backend-${var.environment}"
  protocol              = "HTTP"
  port_name             = "http"
  timeout_sec           = 10
  load_balancing_scheme = "EXTERNAL"

  backend {
    group = google_compute_region_instance_group_manager.web_app_group.instance_group
  }
 
  health_checks = [google_compute_health_check.web_app.self_link]

  depends_on = [google_compute_health_check.web_app]
}

# URL Map for routing requests
resource "google_compute_url_map" "web_url_map" {
  name            = "web-url-map-${var.environment}"
  default_service = google_compute_backend_service.web_backend.self_link
}

# Target HTTP Proxy
resource "google_compute_target_http_proxy" "web_http_proxy" {
  name    = "web-http-proxy-${var.environment}"
  url_map = google_compute_url_map.web_url_map.self_link
}

# Global Forwarding Rule (exposes IP and port 80)
resource "google_compute_global_forwarding_rule" "web_forwarding_rule" {
  name                  = "web-forwarding-rule-${var.environment}"
  target                = google_compute_target_http_proxy.web_http_proxy.self_link
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_global_address.web_lb_ip.address
}



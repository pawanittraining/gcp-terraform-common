resource "google_compute_firewall" "web_app_http" {
  name    = "allow-http"
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  direction = "INGRESS"
  priority  = 1000

  source_ranges = ["0.0.0.0/0"]  
  target_tags = ["web"]  
}

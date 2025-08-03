resource "google_compute_network" "vpc_network" {
  name                    = var.network_name
  auto_create_subnetworks = false
  description             = "Custom VPC network for secure workloads"
  routing_mode            = "REGIONAL"
}

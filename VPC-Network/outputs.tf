output "vpc_network_name" {
  description = "The name of the created VPC network"
  value       = google_compute_network.vpc_network.name
}

output "subnet_ids" {
  description = "IDs of the created subnets"
  value       = [for s in google_compute_subnetwork.subnets : s.id]
}


output "firewall_rules" {
  value = [for rule in google_compute_firewall.rules : rule.name]
}
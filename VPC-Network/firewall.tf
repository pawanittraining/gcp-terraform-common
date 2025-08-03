resource "google_compute_firewall" "rules" {
  for_each = local.firewall_rules

  name    = "${var.network_name}-${each.key}"
  network = google_compute_network.vpc_network.id

  direction = each.value.direction
  priority  = each.value.priority

  source_ranges      = lookup(each.value, "source_ranges", null)
  destination_ranges = lookup(each.value, "destination_ranges", null)

  allow {
    protocol = each.value.protocol
    ports    = lookup(each.value, "ports", null)
  }

  description = lookup(each.value, "description", null)
}


locals {
  base_prefix_length     = tonumber(split("/", var.base_cidr_block)[1])
  new_bits               = var.subnet_prefix_length - local.base_prefix_length

  subnets = {
    for index, region in var.subnet_regions :
    "subnet-${region}" => {
      region        = region
      ip_cidr_range = cidrsubnet(var.base_cidr_block, local.new_bits, index)
    }
  }
}


resource "google_compute_subnetwork" "subnets" {
  for_each = local.subnets

  name          = each.key
  ip_cidr_range = each.value.ip_cidr_range
  region        = each.value.region
  network       = google_compute_network.vpc_network.id

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}


# resource "google_compute_subnetwork" "subnets" {
#   for_each = var.subnets

#   name          = each.key
#   ip_cidr_range = each.value.ip_cidr_range
#   region        = each.value.region
#   network       = google_compute_network.vpc_network.id

#   private_ip_google_access = true

#   log_config {
#     aggregation_interval = "INTERVAL_5_SEC"
#     flow_sampling        = 0.5
#     metadata             = "INCLUDE_ALL_METADATA"
#   }

#   description = "Subnet ${each.key} in region ${each.value.region} with flow logs"
# }

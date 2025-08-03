variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "Primary region for the subnets"
  type        = string
  default     = "us-central1"
}

# variable "subnets" {
#   description = "Map of subnet names to IP CIDRs and regions"
#   type = map(object({
#     ip_cidr_range = string
#     region        = string
#   }))
# }


variable "trusted_ssh_ip" {
  description = "Trusted IP address for SSH access (CIDR format)"
  type        = string
}

variable "network_name" {
  description = "Name of the network to attach firewall rules"
  type        = string
}


variable "base_cidr_block" {
  description = "Base CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_prefix_length" {
  description = "Prefix length for each subnet (e.g., 20 for /20)"
  type        = number
  default     = 20
}

variable "subnet_regions" {
  description = "List of regions where subnets will be created"
  type        = list(string)
  default     = ["us-central1", "us-east1", "us-west1"]
}

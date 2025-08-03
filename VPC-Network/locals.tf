locals {
  firewall_rules = {
    allow-internal = {
      direction     = "INGRESS"
      priority      = 1000
      source_ranges = ["10.0.0.0/16"]
      protocol      = "all"
      description   = "Allow internal traffic within the VPC"
    }

    allow-ssh = {
      direction     = "INGRESS"
      priority      = 1000
      source_ranges = [var.trusted_ssh_ip]
      protocol      = "tcp"
      ports         = ["22"]
      description   = "Allow SSH from trusted IP"
    }

    allow-http = {
      direction     = "INGRESS"
      priority      = 1000
      source_ranges = [var.trusted_ssh_ip]
      protocol      = "tcp"
      ports         = ["80"]
      description   = "Allow http and https from internet"
    }
    
    allow-https = {
      direction     = "INGRESS"
      priority      = 1000
      source_ranges = [var.trusted_ssh_ip]
      protocol      = "tcp"
      ports         = ["443"]
      description   = "Allow https from internet"
    }
    allow-egress = {
      direction          = "EGRESS"
      priority           = 1000
      destination_ranges = ["0.0.0.0/0"]
      protocol           = "all"
      description        = "Allow all outbound traffic"
    }
  }
}


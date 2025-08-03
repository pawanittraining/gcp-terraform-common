project_id  = "gcp-learning-465509"
region      = "us-central1"
vpc_name    = "demo-vpc"
subnet_name = "gke-subnet"
subnet_primary_cidr = "10.0.144.0/20"
environment = "dev"
machine_type = "e2-small"
node_disk_size_gb = 20
node_disk_type = "pd-standard"
zone         = ["us-central1-a", "us-central1-b"]
tags = [ "dev", "web" ]
common_labels = {
  env     = "dev"
  owner   = "team-1"
  service = "web"
}

node_count = 1

cluster_secondary_range_name  = "gke-pods"
services_secondary_range_name = "gke-services"

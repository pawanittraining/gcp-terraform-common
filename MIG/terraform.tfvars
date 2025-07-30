project_id  = "gcp-learning-465509"
region      = "us-central1"
vpc_name    = "default"
environment = "dev"
machine_type = "e2-micro"
zone         = ["us-central1-a", "us-central1-b"]
image        = "debian-cloud/debian-11"
local_disk   = "NVME"
tags = [ "dev", "web" ]
template_name = "v1"
common_labels = {
  env     = "dev"
  owner   = "team-1"
  service = "web"
}

instance_count = 2
instance_template_image = "web-app-image-dev"
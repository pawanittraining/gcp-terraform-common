variable "region" {
    description = "The GCP region where resources will be created."
    type        = string
}

variable "project_id" {
    description = "The ID of the GCP project where resources will be created."
    type        = string
}

variable "common_labels" {
  type = map(string)
  default = {
    env     = "dev"
    owner   = "team-1"
    service = "web"
  }
}
 variable "node_disk_size_gb" {
  description = "The disk size in GB for the VM instance."
  type        = number
  default     = 20
   
 }

 variable "node_disk_type" {
  description = "The disk type for the VM instance."
  type        = string
  default     = "pd-standard"
   
 }

variable "machine_type" {
  description = "The machine type for the VM instance."
  type        = string
}

variable "environment" {
  description = "The environment for the VM instance."
  type        = string
  default     = "dev"
  
}

variable "zone" {
  description = "The zone where the VM instance will be created."
  type        = list(string)
  default     = ["us-central1-a", "us-central1-b", "us-central1-c"]
  
}


variable "vpc_name" {
  description = "The name of the VPC network."
  type        = string
}


variable "tags" {
  description = "The tags to apply to the VM instance."
  type        = list(string)
  
}

variable "node_count" {
  type    = number
}

variable "subnet_name" {
  type        = string
  description = "The name of an existing subnet in the VPC"
}

variable "cluster_secondary_range_name" {
  description = "The name of the secondary range to use for pods"
  type        = string
}

variable "subnet_primary_cidr" {
  type = string
}

variable "pods_secondary_range_name" {
  default = "gke-pods"
}
variable "pods_secondary_cidr" {
  default = "10.10.0.0/16"
}

variable "services_secondary_range_name" {
  default = "gke-services"
}
variable "services_secondary_cidr" {
  default = "10.20.0.0/20"
}

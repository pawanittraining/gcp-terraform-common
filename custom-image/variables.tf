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

variable "image" {
  description = "The image to use for the VM instance."
  type        = string
  default     = "debian-cloud/debian-11"
}

variable "vpc_name" {
  description = "The name of the VPC network."
  type        = string
}

variable "local_disk" {
  description = "The type of local SSD disk to attach to the VM instance."
  type        = string
  default     = "NVME"
  
}

variable "tags" {
  description = "The tags to apply to the VM instance."
  type        = list(string)
  
}

variable "template_name" {
  description = "The name of the instance template."
  type        = string
}

variable "instance_count" {
  description = "The number of instances in the managed instance group."
  type        = number
  default     = 1
  
}

variable "instance_template_image" {
  description = "The image to use for the instance template."
  type        = string
  default     = "debian-cloud/debian-11"
  
}
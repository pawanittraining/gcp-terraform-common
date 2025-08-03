
# Look up existing VPC and Subnet
data "google_compute_network" "vpc" {
  name    = var.vpc_name
  project = var.project_id
}


resource "google_container_cluster" "primary" {
  name     = "gke-cluster-${var.environment}"
  location = var.region
  project  = var.project_id

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = data.google_compute_network.vpc.self_link
  subnetwork = google_compute_subnetwork.gke_subnet.self_link

  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }
  deletion_protection = false
  depends_on = [google_compute_subnetwork.gke_subnet]
}


resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-node-pool"
  cluster    = google_container_cluster.primary.name
  location   = var.region
  node_count = var.node_count

  node_config {
    machine_type = var.machine_type
    disk_type    = var.node_disk_type    
    disk_size_gb = var.node_disk_size_gb         

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    service_account = google_service_account.gke_sa.email
    labels = var.common_labels
  }
}

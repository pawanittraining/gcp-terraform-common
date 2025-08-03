output "kubernetes_cluster_name" {
  value = google_container_cluster.primary.name
}

output "kubernetes_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "kubernetes_sa_email" {
  value = google_service_account.gke_sa.email
}

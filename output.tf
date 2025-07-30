data "google_compute_region_instance_group" "group_data" {
  self_link = google_compute_region_instance_group_manager.web_app_group.instance_group
}


output "mig_instance_group_self_link" {
  value = data.google_compute_region_instance_group.group_data.self_link
}

output "mig_instance_list" {
  value = data.google_compute_region_instance_group.group_data.instances
}

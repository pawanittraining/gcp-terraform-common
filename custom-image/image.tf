/*
 * This Terraform script creates a custom image from a Google Compute Engine instance.
 * It provisions a VM, stops it, and then creates an image from the stopped VM.
 * terraform destroy -target=google_compute_instance.demo_vm
 * terraform state rm google_compute_image.web_app_image
 * terraform apply -target=google_compute_instance.demo_vm -target=null_resource.stop_vm -target=google_compute_image.web_app_image
 * terraform apply -target=null_resource.stop_vm -target=google_compute_image.web_app_image
 */

resource "google_compute_instance" "demo_vm" {
  name         = "web-app-instance"
  machine_type = var.machine_type
  zone         = var.zone[0]

  tags = var.tags
  labels = merge(var.common_labels, { environment = var.environment }, {
    name = "demo-instance"
  })

  boot_disk {
    initialize_params {
      image = var.image
      labels = merge(var.common_labels, {
        environment = var.environment
      })
    }
  }
  network_interface {
    network = var.vpc_name

    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = file("files/apache.sh")
}

resource "null_resource" "stop_vm" {
  provisioner "local-exec" {
    command = "gcloud compute instances stop ${google_compute_instance.demo_vm.name} --zone ${google_compute_instance.demo_vm.zone}"
  }
}

resource "google_compute_image" "web_app_image" {
  name        = "web-app-image-${var.environment}-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  source_disk = google_compute_instance.demo_vm.boot_disk[0].source
  family      = "custom-debian"
  description = "Custom image created from demo VM for instance group template"
}


# resource "google_compute_instance" "demo_vm" {
#   name         = "web-app-instance"
#   machine_type = var.machine_type
#   zone         = var.zone[0]

#   tags  = var.tags
#   labels = merge(var.common_labels, { environment = var.environment }, {
#     name = "demo-instance"
#   })

#   boot_disk {
#     initialize_params {
#       image = var.image
#       labels = merge(var.common_labels, {
#         environment = var.environment
#       })
#     }
#   }

#   network_interface {
#     network = var.vpc_name

#     access_config {}
#   }

#   metadata_startup_script = file("files/apache.sh")
# }

# # Step 2: Stop the VM before creating the image
# resource "null_resource" "stop_vm" {
#   provisioner "local-exec" {
#     command = "gcloud compute instances stop ${google_compute_instance.demo_vm.name} --zone ${google_compute_instance.demo_vm.zone}"
#   }

#   depends_on = [google_compute_instance.demo_vm]
# }

# # Step 3: Create image from stopped instance
# resource "google_compute_image" "web_app_image" {
#   name        = "web-app-image-${var.environment}-${formatdate("YYYYMMDDhhmmss", timestamp())}"
#   source_disk = google_compute_instance.demo_vm.boot_disk[0].source
#   family      = "custom-debian"
#   description = "Custom image created from demo VM"

#   depends_on = [null_resource.stop_vm]
# }

# # (Optional) Step 4: Delete the instance after image creation
# resource "null_resource" "delete_vm" {
#   provisioner "local-exec" {
#     command = "gcloud compute instances delete ${google_compute_instance.demo_vm.name} --zone ${google_compute_instance.demo_vm.zone} --quiet"
#   }

#   depends_on = [google_compute_image.web_app_image]
# }

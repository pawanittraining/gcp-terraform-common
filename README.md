# GCP Terraform Project: Custom Image, Instance Templates, Managed Instance Group, Global Load Balancer, VPC Network, and GKE Cluster

This Terraform project automates deployment of:

- Custom boot images
- Instance templates
- Managed Instance Groups (MIG)
- Load balancers & firewall rules
- VPC network and subnets
- GKE (Google Kubernetes Engine) cluster
- Terraform remote backend (GCS)
- GitHub Actions CI/CD integration

---
---

## ⚙️ Pre-requisites

Before using this automation setup, ensure the following are configured:

### ✅ 1. Create a GCS Bucket for Terraform State

Terraform needs a remote backend to store its state file:

```bash
gsutil mb -p <YOUR_PROJECT_ID> -l us-central1 gs://terraform-state-bucket-web-app
````

Ensure the bucket name matches what is configured in your Terraform backend block:

```hcl
terraform {
  backend "gcs" {
    bucket = "terraform-state-bucket-web-app"
    prefix = "custom-image"
  }
}
```

---

### ✅ 2. Create a GCP Service Account

This service account will be used by GitHub Actions to deploy infrastructure:

```bash
gcloud iam service-accounts create terraform-deployer \
  --description="Terraform GitHub CI/CD account" \
  --display-name="Terraform Deployer"
```

### ✅ 3. Assign Roles to the Service Account

Grant the following IAM roles (either at project level or via IAM policy):

| Role                                               | Purpose                                |
| -------------------------------------------------- | -------------------------------------- |
| `roles/compute.admin`                              | Manage VM, Instance Templates, MIGs    |
| `roles/storage.admin`                              | Store Terraform state and VM images    |
| `roles/iam.serviceAccountUser`                     | Bind service account in deployments    |
| `roles/resourcemanager.projectIamAdmin` (optional) | If managing IAM policies via Terraform |

```bash
gcloud projects add-iam-policy-binding <YOUR_PROJECT_ID> \
  --member="serviceAccount:terraform-deployer@<YOUR_PROJECT_ID>.iam.gserviceaccount.com" \
  --role="roles/compute.admin"

gcloud projects add-iam-policy-binding <YOUR_PROJECT_ID> \
  --member="serviceAccount:terraform-deployer@<YOUR_PROJECT_ID>.iam.gserviceaccount.com" \
  --role="roles/storage.admin"

gcloud projects add-iam-policy-binding <YOUR_PROJECT_ID> \
  --member="serviceAccount:terraform-deployer@<YOUR_PROJECT_ID>.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountUser"
```

---

### ✅ 4. Create and Download a Service Account Key

```bash
gcloud iam service-accounts keys create terraform-key.json \
  --iam-account=terraform-deployer@<YOUR_PROJECT_ID>.iam.gserviceaccount.com
```

---

### ✅ 5. Save the Key to GitHub Secrets

1. Go to your GitHub repo → **Settings** → **Secrets and Variables** → **Actions**
2. Click **New repository secret**
3. Name it: `GCP_AMANHELPSCLOUD_CUSTOM_IMAGE_BUILD`
4. Paste the **contents** of the `terraform-key.json` file

---

📂 Terraform Code Structure
The project is organized into the following folders:

custom-image/: Contains code to create custom boot images.
instance-template/: Contains code to create instance templates.
managed-instance-group/: Contains code to create managed instance groups.
load-balancer/: Contains code to create global load balancers and firewall rules.
vpc-network/: Contains code to create a custom VPC network and subnets.
gke/: Contains code to create a GKE cluster.

---

🚀 GitHub Actions Workflow
This project includes a GitHub Actions workflow to automate Terraform deployment. The workflow is defined in .github/workflows/terraform.yml.

Workflow Features:
Terraform Initialization:

Initializes the Terraform backend using the GCS bucket.
Terraform Plan and Apply:

Runs terraform plan to preview changes.
Runs terraform apply to deploy infrastructure.
Support for VPC and GKE:


## 🔁 Running the Terraform Workflow

### Manually via GitHub UI

1. Go to **Actions** tab in your repository
2. Select **Terraform GCP Multi-Module Workflow**
3. Click **Run workflow**
4. Provide:

   * **module**: `custom-image` or `MIG` or `VPC-Network` or `gke`
   * **action**: `apply` or `destroy`
5. Click **Run workflow**

### Using GitHub CLI

```bash
gh workflow run "Terraform GCP Multi-Module Workflow" \
  -f module=custom-image \
  -f action=apply
```

Replace values as per requirement (`MIG`, `destroy`, etc.)

---

## 📁 Directory Structure

```bash
├── MIG
│   ├── firewall.tf
│   ├── instance_group.tf
│   ├── instane_template.tf
│   ├── load_balancer_mig.tf
│   ├── output.tf
│   ├── provider.tf
│   ├── terraform.tfvars
│   └── variables.tf
├── custom-image
│   ├── files/
│   │   └── apache.sh
│   ├── image.tf
│   ├── output.tf
│   ├── provider.tf
│   ├── terraform.tfvars
│   └── variables.tf
├── .github/
│   └── workflows/
│       └── terraform.yml
├── README.md
```

---

## ✅ Terraform Backend Sample

Inside each module (e.g., `custom-image/provider.tf`):

```hcl
terraform {
  backend "gcs" {
    bucket = "terraform-state-bucket-web-app"
    prefix = "custom-image"
  }
}
```

---

## 🌐 Notes

* Always keep your service account key secure — never commit it.
* Use `terraform.tfvars` in each module directory to override variables.
* Use the `terraform destroy` action carefully — it tears down infrastructure.

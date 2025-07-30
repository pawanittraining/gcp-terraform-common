# Terraform on GCP with GCS Backend

This project provisions Google Cloud resources using Terraform and stores the Terraform state file in a **Google Cloud Storage (GCS)** bucket.

## 📁 Project Structure

# GCP Terraform Project: Custom Image & Managed Instance Group

This Terraform project automates deployment of:

- Custom boot images
- Instance templates
- Managed Instance Groups (MIG)
- Load balancers & firewall rules
- Terraform remote backend (GCS)
- GitHub Actions CI/CD integration

--- 

## ⚙️ Pre-requisites


---
## Setup Instructions

### 1. Enable Required APIs
```bash
gcloud services enable compute.googleapis.com iam.googleapis.com cloudresourcemanager.googleapis.com

PROJECT_ID=<your-project-id>

gcloud iam service-accounts create terraform-deployer \
  --description="Terraform deployer" \
  --display-name="Terraform Deployer"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:terraform-deployer@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/compute.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:terraform-deployer@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/storage.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:terraform-deployer@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountUser"

# Optional: for IAM management via Terraform
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:terraform-deployer@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/resourcemanager.projectIamAdmin"

## ☁️ Setup GCS Remote Backend

Create a GCS bucket to store Terraform state:

```bash
# Set your GCP project
gcloud config set project <your-project-id>

# Create bucket (change region if needed)
gsutil mb -l us-central1 -p <your-project-id> gs://terraform-state-bucket-web-app


# GitHub Actions Terraform Workflow for GCP Multi-Module Deployment

This GitHub Actions workflow enables you to run Terraform commands (`apply` or `destroy`) on specific Terraform modules (`custom-image` or `MIG`) within this repository.

---

## Workflow Overview

- **Modules:**  
  - `custom-image` — For building custom VM images.  
  - `MIG` — For Managed Instance Group resources.

- **Actions:**  
  - `apply` — Run `terraform apply` to provision resources.  
  - `destroy` — Run `terraform destroy` to tear down resources.

---

## Authentication Setup

To allow GitHub Actions to deploy resources on GCP, you must:

### 1. Create a Service Account in GCP

Use the following roles to enable Terraform provisioning:

- `roles/compute.admin`
- `roles/storage.admin`
- `roles/iam.serviceAccountUser`
- `roles/resourcemanager.projectIamAdmin` (optional, for advanced IAM management)

### 2. Create and Download a JSON Key

```bash
gcloud iam service-accounts keys create terraform-key.json \
  --iam-account=terraform-deployer@<YOUR_PROJECT_ID>.iam.gserviceaccount.com



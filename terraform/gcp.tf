terraform {
  required_version = ">= 0.11.11"
}

# This file contains all the interactions with Google Cloud
provider "google" {
  region  = "${var.region}"
  project = "${var.project}"
}

# Generate a random id for the project - GCP projects must have globally
# unique names
resource "random_id" "random" {
  prefix      = "${var.project_prefix}"
  byte_length = "8"
}

# Create the project
 resource "google_project" "provisioner-project" {
   name            = "${random_id.random.hex}"
   project_id      = "${random_id.random.hex}"
   org_id          = "${var.org_id}"
   billing_account = "${var.billing_account}"
 }

# Enable APIs

# Cloud Resource Manager API: Creates, reads, and updates metadata for Google Cloud Platform resource containers.
resource "google_project_service" "cloud_resource_manager_api" {
  service = "cloudresourcemanager.googleapis.com"
  project = "${google_project.provisioner-project.project_id}"
  disable_on_destroy = false
}
# Google Service Management allows service producers to publish their services on Google Cloud
resource "google_project_service" "service_management_api" {
  service = "servicemanagement.googleapis.com"
  project = "${google_project.provisioner-project.project_id}"
  disable_on_destroy = false
}

# Google Service Management allows service producers to publish their services on Google Cloud
resource "google_project_service" "iam_api" {
  service = "iam.googleapis.com"
  project = "${google_project.provisioner-project.project_id}"
  disable_on_destroy = false
}


# Google Service Management allows service producers to publish their services on Google Cloud
resource "google_project_service" "cloud_billing_api" {
  service = "cloudbilling.googleapis.com"
  project = "${google_project.provisioner-project.project_id}"
  disable_on_destroy = false
}

# END Enable APIs

# Create the provisioner service account
resource "google_service_account" "provisioner-svc" {
  account_id   = "provisioner-svc"
  display_name = "provisioner-svc"
  project      = "${google_project.provisioner-project.project_id}"
}

# Create a service account key
resource "google_service_account_key" "provisioner" {
  service_account_id = "${google_service_account.provisioner-svc.name}"
}
#Download private key to local folder
resource "local_file" "provisioner-svc-private" {
    content     = "${base64decode(google_service_account_key.provisioner.private_key)}"
    filename = "~/provisioner-svc.json"
}

# Add the service account to the project
resource "google_project_iam_member" "service-account" {
  count   = "${length(var.service_account_iam_roles)}"
  project = "${google_project.provisioner-project.project_id}"
  role    = "${element(var.service_account_iam_roles, count.index)}"
  member  = "serviceAccount:${google_service_account.provisioner-svc.email}"
}


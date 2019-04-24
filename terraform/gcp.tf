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

# Create the provisioner project
 #resource "google_project" "provisioner-project" {
 #  name = "provisioner-project"
 #  project_id      = "${random_id.random.dec}"
 #  org_id          = "${var.org_id}"
 #  billing_account = "${var.billing_account}"
 #}
###############

# Enable APIs

# Cloud Resource Manager API: Creates, reads, and updates metadata for Google Cloud Platform resource containers.
resource "google_project_service" "cloud_resource_manager_api" {
  service = "cloudresourcemanager.googleapis.com"
  project = "${google_project.provisioner-project.project_id}"
  disable_on_destroy = false
}


# Create the provisioner service account
resource "google_service_account" "provisioner-svc" {
  account_id   = "provisioner-svc"
  display_name = "provisioner-svc"
  project      = "${google_project.provisioner-project.project_id}"
}

# Add the service account to the project
resource "google_project_iam_member" "service-account" {
  count   = "${length(var.service_account_iam_roles)}"
  project = "${google_project.provisioner-project.project_id}"
  role    = "${element(var.service_account_iam_roles, count.index)}"
  member  = "serviceAccount:${google_service_account.provisioner-svc.email}"
}

#resource "google_organization_iam_member" "binding" {
#  org_id = "943433058474"
#  role    = "roles/resourcemanager.projectCreator",
#  member  = "serviceAccount:tf-ignw-project-manager@ignw-terraform-admin.iam.gserviceaccount.com"
#}

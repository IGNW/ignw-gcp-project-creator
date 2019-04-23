terraform {
  required_version = ">= 0.11.11"
}

# This file contains all the interactions with Google Cloud
provider "google" {
  region  = "${var.region}"
  project = "${var.project}"
}

# Create the provisioner project
 resource "google_project" "provisioner-project" {
   org_id          = "${var.org_id}"
   billing_account = "${var.billing_account}"
 }
###############

# Create the provisioner service account
resource "google_service_account" "provisioner-svc" {
  account_id   = "provisioner-svc"
  display_name = "provisioner-svc"
  project      = "${google_project.provisioner-project.project_id}"
}

# Create provisioner service account key
resource "google_service_account_key" "vault" {
  service_account_id = "${google_service_account.provisioner-svc.name}"
}

# Add the service account to the project
resource "google_project_iam_member" "service-account" {
  count   = "${length(var.service_account_iam_roles)}"
  project = "${google_project.provisioner-project.project_id}"
  role    = "${element(var.service_account_iam_roles, count.index)}"
  member  = "serviceAccount:${google_service_account.provisioner-svc.email}"
}
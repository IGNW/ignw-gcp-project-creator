terraform {
  required_version = ">= 0.11.11"
   backend "gcs" {
    bucket  = "tf-state-dev-tc"
    prefix  = "terraform/state"
    project = "ignw-terraform-admin"
   }
}
provider "google" {
  region  = "${var.region}"
  project = "${var.project}"
}



# Create the Project 
resource "google_project" "provisioner-project" {
   name            = "provisioner-poc1"
   project_id      = "provisioner-poc1"
   org_id          = "${var.org_id}"
   billing_account = "${var.billing_account}"

}

# Enable APIs
resource "google_project_services" "apis" {
	project = "${google_project.provisioner-project.project_id}"

	services = [
		"cloudresourcemanager.googleapis.com",
		"servicemanagement.googleapis.com",
    "iam.googleapis.com",
    "cloudbilling.googleapis.com",
    "container.googleapis.com",
    "cloudkms.googleapis.com",
    "compute.googleapis.com",
	]
  disable_on_destroy = true
  depends_on   = ["google_project.provisioner-project"]
}

# Create the provisioner service account
resource "google_service_account" "provisioner-svc" {
  account_id   = "provisioner-svc"
  display_name = "provisioner-svc"
  project      = "${google_project.provisioner-project.project_id}"
  depends_on   = ["google_project_services.apis"]
}
resource "google_service_account_key" "provisioner-poc-key" {
  service_account_id = "${google_service_account.provisioner-svc.name}"
  public_key_type = "TYPE_X509_PEM_FILE"
}

# Add roles to provisioner acct  NOTE: # still needs "roles/resourcemanager.projectCreator" won't take array, requires single role
resource "google_project_iam_member" "provisioner-project" {
  project = "${google_project.provisioner-project.project_id}"
  role    = "roles/billing.projectManager"                    
  member  = "serviceAccount:${google_service_account.provisioner-svc.email}"
}


# Create Keyring:

resource "google_kms_key_ring" "provisioner-ring" {
  name     = "provisioner-ring"
  location = "${var.region}"
  project      = "${google_project.provisioner-project.project_id}"
  depends_on   = ["google_project_iam_member.provisioner-project"]
}

#Create Key
resource "google_kms_crypto_key" "provisioner-key" {
  name            = "provisioner-key"
  #location        = "${var.region}"
  key_ring        = "${google_kms_key_ring.provisioner-ring.self_link}"
  depends_on   = ["google_kms_key_ring.provisioner-ring"]

  lifecycle {
    prevent_destroy = false
  }
}



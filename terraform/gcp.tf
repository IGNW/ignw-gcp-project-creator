terraform {
  required_version = ">= 0.11.11"
   backend "gcs" {
    bucket  = "tf-state-dev-twc"
    prefix  = "terraform/state"
    project = "provisioner-project0"
   }
}
provider "google" {
  region  = "${var.region}"
  project = "${var.project}"
}



# Create the Project 
resource "google_project" "provisioner-project0" {
   name            = "provisioner-poc0"
   project_id      = "provisioner-poc0"
   org_id          = "${var.ORG_ID}"
   billing_account = "${var.BILLING_ACCOUNT}"

}

# Enable APIs
resource "google_project_services" "apis" {
	project = "${google_project.provisioner-project0.project_id}"

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
  depends_on   = ["google_project.provisioner-project0"]
}

# Create the provisioner service account
resource "google_service_account" "provisioner-svc" {
  account_id   = "provisioner-svc"
  display_name = "provisioner-svc"
  project      = "${google_project.provisioner-project0.project_id}"
  depends_on   = ["google_project_services.apis"]
}
resource "google_service_account_key" "provisioner-poc-key" {
  service_account_id = "${google_service_account.provisioner-svc.name}"
  public_key_type = "TYPE_X509_PEM_FILE"
}

# Add roles to provisioner acct  NOTE: # still needs "roles/resourcemanager.projectCreator" won't take array, requires single role
resource "google_project_iam_member" "provisioner-project0" {
  project = "${google_project.provisioner-project0.project_id}"
  role    = "roles/billing.projectManager"                    
  member  = "serviceAccount:${google_service_account.provisioner-svc.email}"
}
	Application connects via AG listener name



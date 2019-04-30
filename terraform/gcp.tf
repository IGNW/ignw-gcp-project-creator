terraform {
  required_version = ">= 0.11.11"
}
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
# Create folder under existing folder (Development folder name, in this case "Internal IGNW Work")
 resource "google_folder" "provisioner" {
  display_name = "provisioner"
  parent     = "folders/${var.folder_id}" # folder name: Internal IGNW Work
}

# Create the Project under the the new Provisioner/ folder, Internal IGNW Work --> Provisioner
resource "google_project" "provisioner-project" {
   name            = "${random_id.random.hex}"
   project_id      = "${random_id.random.hex}"
  folder_id        = "${google_folder.provisioner.name}"
}


# Enable APIs

resource "google_project_services" "apis" {
	project = "${google_project.provisioner-project.project_id}"

	services = [
		"cloudresourcemanager.googleapis.com",
		"servicemanagement.googleapis.com.com",
    "servicemanagement.googleapis.com.com",
    "iam.googleapis.com",
    "cloudbilling.googleapis.com",
    "container.googleapis.com"
	]
  disable_on_destroy = false
}


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

# Pulls key json into Kubernetes secret
resource "kubernetes_secret" "provisioner-svc-credentials" {
  metadata = {
    name = "provisioner-svc-credentials"
  }

  data {
    credentials.json = "${base64decode(google_service_account_key.provisioner.private_key)}"
  }
}
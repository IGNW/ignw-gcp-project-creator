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

# Create the Project 
resource "google_project" "provisioner-project" {
   name            = "${random_id.random.hex}"
   project_id      = "${random_id.random.hex}"
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
	]
  disable_on_destroy = true
}

# Create the provisioner service account
resource "google_service_account" "provisioner-svc" {
  account_id   = "provisioner-svc"
  display_name = "provisioner-svc"
  project      = "${google_project.provisioner-project.project_id}"
  depends_on   = ["google_project_services.apis"]
}



# Create Keyring:

resource "google_kms_key_ring" "provisioner-ring" {
  name     = "provisioner-ring"
  location = "${var.region}"
  project      = "${google_project.provisioner-project.project_id}"
  depends_on   = ["google_service_account.provisioner-svc"]
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

#resource "google_kms_crypto_key_iam_binding" "provisioner-key" {
#  crypto_key_id = "${google_project.provisioner-project.project_id}/${var.region}/provisioner-ring/provisioner-key"
#  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
#
#  members = [
#    "serviceAccount:${google_service_account.provisioner-svc.name}"
#  ]
#}

resource "google_kms_crypto_key_iam_member" "provisioner-key" {
  #crypto_key_id = "${google_project.provisioner-project.project_id}/${var.region}/provisioner-ring/provisioner-key"
  crypto_key_id = "provisioner-a4346f6b65415d91/us-west2/provisioner-ring/provisioner-key"
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${google_service_account.provisioner-svc.name}"
  depends_on   = ["google_kms_crypto_key.provisioner-key"]
  }
#projects/provisioner-a4346f6b65415d91/locations/us-west2/keyRings/provisioner-ring/cryptoKeys/provisioner-key
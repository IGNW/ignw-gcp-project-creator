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
  depends_on   = ["google_project.provisioner-project"]
}

# Create the provisioner service account
resource "google_service_account" "provisioner-svc" {
  account_id   = "provisioner-svc"
  display_name = "provisioner-svc"
  project      = "${google_project.provisioner-project.project_id}"
  depends_on   = ["google_project_services.apis"]
}


# Add the service account to the project
resource "google_project_iam_member" "provisioner-svc" {
  count   = "${length(var.service_account_iam_roles)}"
  project = "${google_project.provisioner-project.project_id}"
  role    = "${element(var.service_account_iam_roles, count.index)}"
  member  = "serviceAccount:${google_service_account.provisioner-svc.name}"
  depends_on   = ["google_service_account.provisioner-svc"]
}

# Create Keyring:

resource "google_kms_key_ring" "provisioner-ring" {
  name     = "provisioner-ring"
  location = "${var.region}"
  project      = "${google_project.provisioner-project.project_id}"
  depends_on   = ["google_project_iam_member.provisioner-svc"]
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


# Successfully executed

/* 
gcloud kms keys add-iam-policy-binding "provisioner-key" \
  --location us-west2 \
  --keyring provisioner-ring \
  --member serviceAccount:provisioner-svc@provisioner-fae5d0670337b8e9.iam.gserviceaccount.com \
  --role roles/cloudkms.cryptoKeyEncrypterDecrypter \
  --project provisioner-fae5d0670337b8e9
  */

  # Successfully executed
  
  /*
  gcloud beta container clusters create provisioner-cluster2 \
  --cluster-version=latest \
  --zone us-west2-a \
  --database-encryption-key projects/provisioner-fae5d0670337b8e9/locations/us-west2/keyRings/provisioner-ring/cryptoKeys/provisioner-key \
  --project provisioner-fae5d0670337b8e9
  */


/*
gcloud beta container clusters describe provisioner-cluster \
  --zone us-west2-a  \
  --format 'value(databaseEncryption)' \
  --project provisioner-fae5d0670337b8e9
  */




# --------------------------
# PAST FAILURES

#resource "google_kms_crypto_key_iam_member" "provisioner-key" {
# crypto_key_id = "${google_project.provisioner-project.project_id}/${var.region}/provisioner-ring/provisioner-key"
# #crypto_key_id = "provisioner-66f06be8df9d2029/us-west2/provisioner-ring/provisioner-key"
# role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
# member        = "serviceAccount:${google_service_account.provisioner-svc.name}"
# depends_on   = ["google_kms_crypto_key.provisioner-key"]
# }

#resource "google_kms_crypto_key_iam_binding" "provisioner-key" {
#  crypto_key_id = "${google_project.provisioner-project.project_id}/${var.region}/provisioner-ring/provisioner-key"
#  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
#
#  members = [
#    "serviceAccount:${google_service_account.provisioner-svc.name}"
#  ]
#}

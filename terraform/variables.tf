variable "region" {
  type    = "string"
  default = "us-west2"
  description = <<EOF
Desired Region
EOF
}

variable "project" {
  type    = "string"
  default = ""
  description = <<EOF
Project ID where Terraform is authenticated to run to create additional
projects.
EOF
}

variable "project_prefix" {
  type    = "string"
  default = "provisioner-"

  description = <<EOF
String value to prefix the generated project ID with.
EOF
}

variable "project_id" {
  type    = "string"
  default = ""
  description = <<EOF
String value for random project_id.
EOF
}

variable "billing_account" {
  type = "string"
  description = <<EOF
Billing account ID.
EOF
}

variable "org_id" {
  default = "943433058474"
  type = "string"
  description = <<EOF
Organization ID.
EOF
}

variable "folder_id" {
  type = "string"
  default = 379554957262
  description = <<EOF
Folder ID.
EOF
}

variable "service_account_iam_roles" {
  type = "list"

  default = [
    "roles/billing.projectManager",
    "roles/resourcemanager.folderAdmin",
    "roles/resourcemanager.folderIamAdmin",
    "roles/resourcemanager.projectIamAdmin",
    "roles/cloudkms.cryptoKeyEncrypterDecrypter",
  ]
}
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
  type = "string"
  description = <<EOF
Organization ID.
EOF
}

resource "google_organization_iam_member" "binding" {
  org_id = "943433058474"
  role    = "roles/resourcemanager.projectCreator",
  member  = "user:tomc@ignw.io"
}

variable "service_account_iam_roles" {
  type = "list"

  default = [
    "roles/billing.projectManager",
    "roles/resourcemanager.folderAdmin",
    "roles/resourcemanager.folderIamAdmin",
    "roles/resourcemanager.projectIamAdmin",
  ]
}
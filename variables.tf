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

#variable "project_prefix" {
#  type    = "string"
#  default = "vault-"
#  description = <<EOF
#String value to prefix the generated project ID with.
#EOF
#}

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
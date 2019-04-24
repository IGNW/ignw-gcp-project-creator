#!/usr/bin/env bash
export TF_LOG=TRACE
export TF_LOG_PATH=./terraform.log
cd terraform
terraform init
TF_VAR_org_id=943433058474 TF_VAR_billing_account=C9D630-DC571C terraform apply
#!/usr/bin/env bash

cd terraform
terraform init
TF_VAR_org_id=943433058474 TF_VAR_billing_account=01160D-C9D630-DC571C terraform validate 

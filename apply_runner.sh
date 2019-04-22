#!/usr/bin/env bash

cd terraform
terraform init
TF_VAR_org_id=<ORGID> TF_VAR_billing_account=<BILLINGID> terraform apply

#!/usr/bin/env bash

cd terraform
terraform init
TF_VAR_ORG_ID=943433058474 TF_VAR_BILLING_ACCOUNT=01160D-C9D630-DC571C terraform destroy 
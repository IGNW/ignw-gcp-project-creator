# IGNW GCP Project Provisioner

Creates a privileged service account and key for purpose of project admin. Private key is rendered in remote state.

## Installion Requirements

1. An empty project must be created before TF run.
2. Remote state bucket must created inside empty project before TF run. In the example below, `provisioner-project0` is the name of your pre-created project.
3. Inside the new project, GCS bucket must be named with the value in `bucket=`

```
terraform {
  required_version = ">= 0.11.11"
   backend "gcs" {
    bucket  = "tf-state-dev-twc"
    prefix  = "terraform/state"
    project = "provisioner-project0"
   }
}


```
4. Terraform and GCPCloud SDK installed



## Deployment 

Runners have been supplied to plan, apply, trace, and destroy for this repo. They are:

* plan_runner.sh
* apply_runner.sh
* trace_runner.sh
* trace_runner.sh

You will need to change the two vars in each runner to your GCP organizationID and billing account you want the project billed to.

* TF_VAR_ORG_ID
* TF_VAR_BILLING_ACCOUNT

Example:

```
#!/usr/bin/env bash

cd terraform
terraform init
TF_VAR_ORG_ID=<value here> TF_VAR_BILLING_ACCOUNT=<value here> terraform plan


```

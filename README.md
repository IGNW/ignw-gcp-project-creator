# IGNW GCP Project Provisioner

Creates a privileged service account and key for purpose of project admin. Private key is encrypted at-rest in remote state GCS bucket.

## Installion Requirements

1. An empty project must be created before the initial Terrform run.
2. Remote state bucket must created inside empty project before initial Terrafom run. In the example below, `provisioner-project0` is the name of your pre-created project. Create the bucket in this project.
3. In the Terraform code, alter the GCS bucket backend value to the name of the bucket in Step #2.


Example:

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
4. Alter the project name if desired.

5. Terraform and GCP Cloud SDK must be installed



## Deployment 

Runners have been supplied to plan, apply, trace, and destroy for this repo. They are:

* `plan_runner.sh`
* `apply_runner.sh`
* `trace_runner.sh`
* `trace_runner.sh`

You will need to change the two vars in each runner to your GCP organization ID and billing account ID.

* TF_VAR_ORG_ID
* TF_VAR_BILLING_ACCOUNT

Example:

```
#!/usr/bin/env bash

cd terraform
terraform init
TF_VAR_ORG_ID=<value here> TF_VAR_BILLING_ACCOUNT=<value here> terraform plan


```

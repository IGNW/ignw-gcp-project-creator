# IGNW GCP Project Provisioner

Creates a privileged GCP provisioner project and service account for purpose of project and folder management.



## Testing Notes (remove after acceptance)

 1. Create the provsioning svc account by running the `ignw-gcp-project-provisioner` repo.
 2. Private key for svc account is downloaded to local folder on successful run.
 3. Change new key credential path in EXPORT var, e.g, export `GOOGLE_CLOUD_KEYFILE_JSON=~path/to/provisioner-svc.json`
 4. Log out of current gcloud identity:

```
# log out
gcloud auth revoke tomc@ignw.io

```
 5. Log in with new provisioner svc acct:

```
 # Login to SDK with service account:
gcloud auth activate-service-account tf-ignw-project-manager@ignw-terraform-admin.iam.gserviceaccount.com --key-file=/Users/TomC/.config/gcloud/ignw-terraform-admin.json

```
 6. Kill local TF state file
 7. Rerun `ignw-gcp-project-provisioner`  again. 
 8. New project and svc account successfully created.

*Currently experimenting with changing storage of private key from local to Kubernetes secret or to GCS

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
## Deployment

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

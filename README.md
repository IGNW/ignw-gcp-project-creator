# IGNW GCP Provisioner

Creates a privileged GCP provisioner project and service account for purpose of project and folder management.

On a top level project, or within an individual project, It is strongly recommended to isolate project and folder management. This is because these resource types will require heightened service account privileges. In some cases even organization-level control. It is desired that very few administrators have access to such service accounts.

When dealing with multi-tenancy, a “project of projects” pattern can really help organizations manage potential sprawl. In this model, we use a master project to drive the creation of all other projects within the account. 

Additionally, a superuser service account is created here, with abilities to control organization-wide objects such as folders and projects and objects that need organizational approval, such as certain network changes. 

Users should not be using this project for any development or production purposes, and this service account should be interacted with only through a CI/CD process. This is your GCP/Terraform management plane, and should be secured as such.

## Testing Notes (Remove After Acceptance)

 1. Create the provsioning svc account by running the gcp provisioner repo.
 2. Private key for svc account is downloaded to local folder on successful run.
 3. Change new key credential path in EXPORT var, e.g, export GOOGLE_CLOUD_KEYFILE_JSON=~path/to/provisioner-svc.json
 4. Log out of current gcloud identity:

```
# log out
gcloud auth revoke tomc@ignw.io

```
 5. Log in with new provisioner svc acct:

```
 # Login to SDK with service account:
gcloud auth activate-service-account provisioner-svc@provisioner-869e551a52fc154b.iam.gserviceaccount.com --key-file=/Users/TomC/provisioner-svc.json

```
 6. Kill local TF state file
 7. Rerun IGNW-GCP-provisioner again. 
 8. New project and svc account successfully created.

 Currently experimenting with changing storage of private key from local to Kubernetes secret.

## Installion Requirements

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

## Deployment

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

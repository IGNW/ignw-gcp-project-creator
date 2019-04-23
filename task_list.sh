#!/usr/bin/env bash

#IGNW Org ID: 943433058474
#IGNW Billing Account: 01160D-C9D630-DC571C

# Need a safety switch...
rm -rf .terraform

set -e
echo "Please supply name for provisioner project"
read -r projectname
gcloud projects create "$projectname"

echo "Please supply name for provisioner service account"
read -r provisionername
gcloud --project "$projectname" iam service-accounts create "$provisionername" \
--display-name "$provisionername"


svcacc=$(gcloud iam service-accounts list --project "$projectname" | grep "$provisionername" | awk '{ print $2 }')

echo "Please supply GCP organization ID number (gcloud organizations list)"
read -r orgname
#gcloud organizations add-iam-policy-binding "$orgname" \
#  --member="serviceAccount:$svcacc" \
#  --role="roles/resourcemanager.organizationAdmin"

gcloud projects add-iam-policy-binding "$projectname" \
 --member="serviceAccount:$svcacc" \
 --role="roles/owner"

echo "Please provide gcp billing account ID"
read billing_account_id
gcloud beta billing projects link "$projectname" --billing-account="$billing_account_id"

gcloud --project "$projectname" services enable cloudresourcemanager.googleapis.com
gcloud --project "$projectname" services enable iam.googleapis.com
gcloud --project "$projectname" services enable cloudbuild.googleapis.com
gcloud --project "$projectname" services enable servicemanagement.googleapis.com
gcloud --project "$projectname" services enable cloudbilling.googleapis.com

echo "Please retrieve JSON credentials for serviceAccount:$svcacc and provide the path on disk"
read json_creds
export GOOGLE_CREDENTIALS=$json_creds

cd prereqs
terraform workspace new $projectname
terraform workspace select $projectname
terraform init
terraform apply -auto-approve
cd ..
terraform init -backend-config="bucket=$projectname-tf-state"
terraform workspace new $projectname
terraform workspace select $projectname
terraform apply

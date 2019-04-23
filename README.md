# IGNW GCP Provisioner

Creates a privileged GCP provisioner project and service account for purpose of project and folder management.

On a top level project, or within an individual project, It is strongly recommended to isolate project and folder management. This is because these resource types will require heightened service account privileges. In some cases even organization-level control. It is desired that very few administrators have access to such service accounts.

When dealing with multi-tenancy, a “project of projects” pattern can really help organizations manage potential sprawl. In this model, we use a master project to drive the creation of all other projects within the account. 

Additionally, a superuser service account is created here, with abilities to control organization-wide objects such as folders and projects and objects that need organizational approval, such as certain network changes. 

Users should not be using this project for any development or production purposes, and this service account should be interacted with only through a CI/CD process. This is your GCP/Terraform management plane, and should be secured as such.

## Getting Started



### Prerequisites


### Installing


## Deployment

Add additional notes about how to deploy this on a live system

## Tool Manifest

* [tools](http://www.tools-path.com) - Tools used
* [more tools](https://www.tools-path.com) - More tools used



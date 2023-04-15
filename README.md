# Postgresql Master / Standby Replication - GCP

This solution implements a Master and Standby Postgres server setup to showcase replication. The entire infrastructure is constructed using Terraform.

Terraform modules have been parameterized to enable easy reuse or modification by other engineers without the need for additional adjustments. A Makefile has been employed to streamline the deployment process and CI/CD pipeline.


## Assumptions and Configuration Choices:

- SSH keys are not provisioned on the instances via Terraform, under the assumption that the cloud console can be utilized for SSH access.


- For Postgres authentication, the 'Trust' mode has been implemented for replication, eliminating the need for a password. However, in a production environment, passwords should be securely stored in Google Secret Manager and dynamically utilized during server provisioning and replication configuration.


- The current configuration assigns public IPs to the servers. However, for a production environment, public IPs should be removed. It is recommended to deploy databases within a private subnet for enhanced security.


- The current configuration setup postgres server using Terraform but in the production environment I would use Anisble or other similar configuration management tools.I have used Terraform to keep the home assignment simple.

## Requirements

- Terraforn v1.1.2 (or newer)
The solution is implemented using Terraform v1.1.2 please use appropriate Terraform version to run.

- GNU Make 3.81 (optional)


## Terraform State

Terraform state is stored in a versioning enabled cloud storage bucket.

## Database Initialization

Database initialized using pgbench

```
pgbench -i -h 10.0.0.7 -p 5432 demo -s 50
```

## Deployment

The solution has been tested on a Mac, utilizing a Makefile to bootstrap variable values and deploy the infrastructure. Alternatively, you can also employ Terraform commands for deployment.

Prior to deploying the solution, ensure that you have a Google Cloud account and a service account created, with the service account key downloaded to your local machine.

Next, update the provider.tf file accordingly.

```
provider "google" {
  # update this line as per your file path and name
  credentials = file("../gcp-credential.json") 
  project     = "toggle-pgsql"
  region      = "us-central1"
  zone        = "us-central1-a"
}
```

###### Deploy the solution using Makefile

Makefile is just wrapper for terraform commands I used to deploy the solution.

```
make init apply
```

above command will deploy the solution.

###### Deploy the solution using Terraform commands

```
terraform init
```
```
terraform apply
```



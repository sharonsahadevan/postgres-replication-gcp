# Variables
PROJECT_ID = your-project-id
REGION = us-central1
MASTER_INSTANCE_TYPE = n1-standard-2
STANDBY_INSTANCE_TYPE = n1-standard-1
MASTER_IMAGE = projects/ubuntu-os-cloud/global/images/family/ubuntu-2004-lts
STANDBY_IMAGE = projects/ubuntu-os-cloud/global/images/family/ubuntu-2004-lts
MASTER_POSTGRES_VERSION = 13
STANDBY_POSTGRES_VERSION = 13
MASTER_PASSWORD = your-master-password
STANDBY_PASSWORD = your-standby-password

.PHONY: init apply

init:
	terraform init

apply:
	terraform apply -auto-approve \
		-var project_id=$(PROJECT_ID) \
		-var region=$(REGION) \
		-var master_instance_type=$(MASTER_INSTANCE_TYPE) \
		-var standby_instance_type=$(STANDBY_INSTANCE_TYPE) \
		-var master_image=$(MASTER_IMAGE) \
		-var standby_image=$(STANDBY_IMAGE) \
		-var master_postgres_version=$(MASTER_POSTGRES_VERSION) \
		-var standby_postgres_version=$(STANDBY_POSTGRES_VERSION) \
		-var master_password=$(MASTER_PASSWORD) \
		-var standby_password=$(STANDBY_PASSWORD)

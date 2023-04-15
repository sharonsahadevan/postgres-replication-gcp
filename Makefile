# Variables
PROJECT_ID = toggle-pgsql
REGION = us-central1
MASTER_INSTANCE_TYPE = e2-micro
STANDBY_INSTANCE_TYPE = e2-micro


.PHONY: init apply

init:
	terraform init

apply:
	terraform apply -auto-approve \
		-var project_id=$(PROJECT_ID) \
		-var region=$(REGION) \
		-var master_instance_type=$(MASTER_INSTANCE_TYPE) \
		-var standby_instance_type=$(STANDBY_INSTANCE_TYPE) 

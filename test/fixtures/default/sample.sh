export TF_VAR_project_id=container-vm-test
export TF_VAR_subnetwork=default
export TF_VAR_credentials_path="credentials.json"

## These values you can potentially leave at the defaults
export TF_VAR_instance_name=container-vm-test
export TF_VAR_image=gcr.io/cloud-marketplace/google/nginx1:1.12
export TF_VAR_machine_type="n1-standard-1"
export TF_VAR_subnetwork_project="${TF_VAR_project_id}"
export TF_VAR_region="us-east4"
export TF_VAR_zone="us-east4-b"

export CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE="${TF_VAR_credentials_path}"

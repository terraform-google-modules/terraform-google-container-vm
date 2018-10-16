# Simple Instance

This example illustrates how to deploy a container to a Google Compute Engine instance in GCP.

[^]: (autogen_docs_start)


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| credentials_path | The path to a valid service account JSON credentials file | string | - | yes |
| image | The Docker image to deploy to GCE instances | string | - | yes |
| instance_name | The desired name to assign to the deployed instance | string | - | yes |
| machine_type | The GCP machine type to deploy | string | - | yes |
| project_id | The project ID to deploy resource into | string | - | yes |
| region | The GCP region to deploy instances into | string | - | yes |
| restart_policy | The desired Docker restart policy for the deployed image | string | - | yes |
| subnetwork | The name of the subnetwork to deploy instances into | string | - | yes |
| subnetwork_project | The project ID where the desired subnetwork is provisioned | string | - | yes |
| zone | The GCP zone to deploy instances into | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| container |  |
| credentials_path |  |
| http_address |  |
| image |  |
| instance_name |  |
| ipv4 |  |
| machine_type |  |
| project_id |  |
| region |  |
| restart_policy |  |
| subnetwork |  |
| subnetwork_project |  |
| vm_container_label |  |
| volumes |  |
| zone |  |

[^]: (autogen_docs_end)

## Running

To provision this example, run the following from within this directory:

- `terraform init` to get plugins
- `terraform plan` to dry-run the infrastructure changes
- `terraform apply` to apply the infrastructure changes
- `terraform destroy` to tear down the created infrastructure
# Simple Instance

This example illustrates how to deploy a container to a Google Compute Engine instance in GCP.

[^]: (autogen_docs_start)


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| instance_name | The desired name to assign to the deployed instance | string | `hello-world-container-vm` | no |
| project_id | The project ID to deploy resources into | string | - | yes |
| region | The GCP region to deploy instances into | string | - | yes |
| subnetwork | The name of the subnetwork to deploy instances into | string | - | yes |
| subnetwork_project | The project ID where the desired subnetwork is provisioned | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| container |  |
| instance_name |  |
| ipv4 |  |
| metadata |  |
| project_id |  |
| region |  |
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
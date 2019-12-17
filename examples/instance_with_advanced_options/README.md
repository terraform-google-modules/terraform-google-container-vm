# Instance with Advanced Options

This example illustrates how to deploy a container to a Google Compute Engine instance in GCP with advanced options.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| client\_email | Service account email address | string | `""` | no |
| instance\_name | The desired name to assign to the deployed instance | string | `"container-vm-advanced-options"` | no |
| project\_id | The project ID to deploy resources into | string | n/a | yes |
| subnetwork | The name of the subnetwork to deploy instances into | string | n/a | yes |
| subnetwork\_project | The project ID where the desired subnetwork is provisioned | string | n/a | yes |
| zone | The GCP zone to deploy instances into | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| container | The container metadata provided to the module |
| instance\_name | The deployed instance name |
| ipv4 | The public IP address of the deployed instance |
| vm\_container\_label | The instance label containing container configuration |
| volumes | The volume metadata provided to the module |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Running

To provision this example, run the following from within this directory:

- `terraform init` to get plugins
- `terraform plan` to dry-run the infrastructure changes
- `terraform apply` to apply the infrastructure changes
- `terraform destroy` to tear down the created infrastructure

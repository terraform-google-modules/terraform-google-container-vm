# Instance with Attached Disk

This example illustrates how to deploy and expose a container to a Google Compute Engine instance in GCP, with an attached disk. Also includes SSH configuration, so a user can be provisioned on the fly for future logins.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_metadata | Additional metadata to attach to the instance | `map(string)` | `{}` | no |
| client\_email | Service account email address | `string` | `""` | no |
| image | The Docker image to deploy to GCE instances | `any` | n/a | yes |
| image\_port | The port the image exposes for HTTP requests | `any` | n/a | yes |
| instance\_name | The desired name to assign to the deployed instance | `string` | `"disk-instance-vm-test"` | no |
| machine\_type | The GCP machine type to deploy | `any` | n/a | yes |
| project\_id | The project ID to deploy resource into | `any` | n/a | yes |
| restart\_policy | The desired Docker restart policy for the deployed image | `any` | n/a | yes |
| subnetwork | The name of the subnetwork to deploy instances into | `any` | n/a | yes |
| subnetwork\_project | The project ID where the desired subnetwork is provisioned | `any` | n/a | yes |
| zone | The GCP zone to deploy instances into | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| container | The container metadata provided to the module |
| http\_address | The IP address on which the HTTP service is exposed |
| http\_port | The port on which the HTTP service is exposed |
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

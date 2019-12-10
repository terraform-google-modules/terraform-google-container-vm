# Managed Instance Group

This example illustrates how to deploy a container to a [managed instance group](https://cloud.google.com/compute/docs/instance-groups/#managed_instance_groups) in GCP. Also includes SSH key configuration, so a user can be provisioned on the fly for future logins.

## Requirements

This example requires that some python libraries be installed, as outlined in `requirements.txt`. Depending on your environment, you should be able to run `pip install -r requirements.txt` to satisfy these requirements.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| additional\_metadata | Additional metadata to attach to the instance | map | `<map>` | no |
| image | The Docker image to deploy to GCE instances | string | `"gcr.io/google-samples/hello-app:1.0"` | no |
| image\_port | The port the image exposes for HTTP requests | number | `"8080"` | no |
| mig\_instance\_count | The number of instances to place in the managed instance group | string | `"2"` | no |
| mig\_name | The desired name to assign to the deployed managed instance group | string | `"mig-test"` | no |
| network | The GCP network | string | `"mig-net"` | no |
| project\_id | The project ID to deploy resource into | string | n/a | yes |
| region | The GCP region to deploy instances into | string | `"us-east4"` | no |
| service\_account |  | object | `<map>` | no |
| subnetwork | The name of the subnetwork to deploy instances into | string | `"mig-subnet"` | no |
| zone | The GCP zone to deploy instances into | string | `"us-east4-b"` | no |

## Outputs

| Name | Description |
|------|-------------|
| container | The container metadata provided to the module |
| http\_address | The IP address on which the HTTP service is exposed |
| http\_port | The port on which the HTTP service is exposed |
| project\_id | The project ID resources were deployed into |
| region | The region the GCE instance was deployed into |
| vm\_container\_label | The instance label containing container configuration |
| volumes | The volume metadata provided to the module |
| zone | The zone the GCE instance was deployed into |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Running

To provision this example, run the following from within this directory:

- `terraform init` to get plugins
- `terraform plan` to dry-run the infrastructure changes
- `terraform apply` to apply the infrastructure changes
- `terraform destroy` to tear down the created infrastructure

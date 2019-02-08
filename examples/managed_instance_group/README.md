# Managed Instance Group

This example illustrates how to deploy a container to a [managed instance group](https://cloud.google.com/compute/docs/instance-groups/#managed_instance_groups) in GCP. Also includes SSH key configuration, so a user can be provisioned on the fly for future logins.

## Requirements

This example requires that some python libraries be installed, as outlined in `requirements.txt`. Depending on your environment, you should be able to run `pip install -r requirements.txt` to satisfy these requirements.

[^]: (autogen_docs_start)


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| additional_metadata | Additional metadata to attach to the instance | map | `<map>` | no |
| image | The Docker image to deploy to GCE instances | string | - | yes |
| image_port | The port the image exposes for HTTP requests | string | - | yes |
| machine_type | The GCP machine type to deploy | string | - | yes |
| mig_instance_count | The number of instances to place in the managed instance group | string | `2` | no |
| mig_name | The desired name to assign to the deployed managed instance group | string | `mig-test` | no |
| project_id | The project ID to deploy resource into | string | - | yes |
| region | The GCP region to deploy instances into | string | - | yes |
| restart_policy | The desired Docker restart policy for the deployed image | string | - | yes |
| subnetwork | The name of the subnetwork to deploy instances into | string | - | yes |
| subnetwork_project | The project ID where the desired subnetwork is provisioned | string | - | yes |
| zone | The GCP zone to deploy instances into | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| container | The container metadata provided to the module |
| http_address |  |
| http_port |  |
| project_id | The project ID resources were deployed into |
| vm_container_label | The instance label containing container configuration |
| volumes | The volume metadata provided to the module |
| zone | The zone the GCE instance was deployed into |

[^]: (autogen_docs_end)

## Running

To provision this example, run the following from within this directory:

- `terraform init` to get plugins
- `terraform plan` to dry-run the infrastructure changes
- `terraform apply` to apply the infrastructure changes
- `terraform destroy` to tear down the created infrastructure
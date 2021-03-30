# Instance with Config File

This example illustrates how to deploy and expose a container to a Google Compute Engine instance in GCP, with an templated config file mounted into the container.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_metadata | Additional metadata to attach to the instance | `map(string)` | `{}` | no |
| client\_email | Service account email address | `string` | `""` | no |
| cos\_image\_name | The forced COS image to use instead of latest | `string` | `"cos-stable-77-12371-89-0"` | no |
| instance\_name | The desired name to assign to the deployed instance | `string` | `"hello-world-container-vm"` | no |
| project\_id | The project ID to deploy resources into | `any` | n/a | yes |
| subnetwork | The name of the subnetwork to deploy instances into | `any` | n/a | yes |
| subnetwork\_project | The project ID where the desired subnetwork is provisioned | `any` | n/a | yes |
| zone | The GCP zone to deploy instances into | `string` | n/a | yes |

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

## Debugging

SSH into the VM instance (e.g. through the cloud console) and run the following commands.

To verify that the startup script wrote the config file:

```
$ cat /etc/hello-app/config.json
{
    "instance_name": "hello-world-container-vm-60b69fa4",
    "boot_timestamp": "2020-09-30T19:37:51,065136954+00:00",
}
```

To verify that the config file can be read from inside the container:

```
$ docker exec "$(docker ps | grep hello-app | cut -f 1 -d ' ')" cat /config.json
{
    "instance_name": "hello-world-container-vm-60b69fa4",
    "boot_timestamp": "2020-09-30T19:37:51,065136954+00:00",
}
```

To debug the startup script, see [viewing startup script logs](https://cloud.google.com/compute/docs/startupscript#viewing_startup_script_logs) and [rerunning a startup script](https://cloud.google.com/compute/docs/startupscript#rerunthescript).

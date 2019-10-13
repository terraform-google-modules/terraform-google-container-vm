# MySQL service on Container Optimized OS

This module implements a MySQL service running as a container on one or more Container Optimized OS instances. The following resources are created and managed by this module:

* `google_compute_address`, one reserved IP address per instance
* `google_compute_disk`, one data disk per instance
* `google_compute_instance`, one or more COS instances
* `google_compute_firewall`, one firewall rule to allow traffic from specific IP ranges to the MySQL port

Variables allow controlling several aspects of the created resurces, like number of instances (`instance_count`), container image used for MySQL (`container_image`), client IP ranges allowed to connect to the service (`client_cidrs`), MySQL configuration file (`my_cnf`).

The `password` and `kms_data` in particular allow different ways of passing the MySQL root password to the container:

- through the auto-generated secret, if no password is provided
- using the provided password as is, if the `kms_data` variable is empty
- decrypting the provided password on the instance using Cloud KMS, if the `kms_data` variable contains values for the `project_id`, `keyring`, `location`, and `key` keys

KMS decryption on the instance leverages the instance service account, which needs the `roles/cloudkms.cryptoKeyDecrypter` role on the provided key. The corresponding KMS scope is added by this module to the instance scopes if a valid KMS configuration is present.

The [official Docker MySQL image](https://hub.docker.com/_/mysql) supports various customization options which are not directly implemented here, but are fairly trivial to add by modifying the `cloud-init` file set on the instance.

## Sample Usage

```hcl
module "mysql" {
  source         = "terraform-google-modules/container-vm/google//modules/cos-mysql"
  instance_count        = "1"
  project_id     = "my-project"
  region         = "europe-west3"
  zone           = "europe-west3-c"
  data_disk_size = "10"
  vm_tags        = ["ssh"]
  password       = "base64_KMS_encrypted_password"
  kms_data = {
    project_id = "my-kms-project-id"
    keyring = "my-keiring"
    key = "my-key"
    location = "europe-west3"
  }
  network        = "my-network-name"
  subnetwork     = "https://www.googleapis.com/compute/v1/projects/my-project/regions/europe-west3/subnetworks/my-subnetwork"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| boot\_disk\_size | Size of boot disk. | number | `"40"` | no |
| client\_cidrs | Client IP CIDR ranges to set in the firewall rule. | list(string) | `<list>` | no |
| container\_image | MySQL container version. | string | `"mysql:5.7"` | no |
| create\_firewall\_rule | Create tag-based firewall rule. | bool | `"false"` | no |
| data\_disk\_size | Size of data disk. | number | n/a | yes |
| data\_disk\_type | Type of data disk. | string | `"pd-ssd"` | no |
| host\_project\_id | VPC host project id if the instance is in a service project. | string | `""` | no |
| instance\_count | Number of instances to create. | number | `"1"` | no |
| instance\_type | Instance machine type. | string | `"n1-standard-2"` | no |
| kms\_data | Map with KMS project_id, keyring, location and key if password is encrypted with KMS. | map(string) | `<map>` | no |
| labels | Labels to be attached to the resources | map(string) | `<map>` | no |
| log\_driver | Docker log driver to use for CoreDNS. | string | `"gcplogs"` | no |
| my\_cnf | Content of the my.cnf file that will be written on the instances. | string | `""` | no |
| mysql\_port | Port MySQL will listen on. | number | `"3306"` | no |
| network | Self link of the VPC subnet to use for firewall rules. | string | n/a | yes |
| network\_tag | Network tag that identifies the instances. | string | `"mysql"` | no |
| password | Provide a plain text on KMS-encrypted password instead of using the auto-generated one. | string | `""` | no |
| prefix | Prefix to prepend to resource names. | string | `""` | no |
| project\_id | Project id where the instances will be created. | string | n/a | yes |
| region | Region for internal addresses. | string | n/a | yes |
| scopes | Instance scopes. | list(string) | `<list>` | no |
| service\_account | Instance service account. | string | `""` | no |
| stackdriver\_logging | Enable the Stackdriver logging agent. | bool | `"true"` | no |
| stackdriver\_monitoring | Enable the Stackdriver monitoring agent. | bool | `"true"` | no |
| subnetwork | Self link of the VPC subnet to use for the internal interface. | string | n/a | yes |
| vm\_tags | Additional network tags for the instances. | list(string) | `<list>` | no |
| zone | Instance zone. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| instances | Instance name => address map. |
| password | Auto-generated password, if no password was set as a variable. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

# Generic Container Optimized OS Instances

This module implements boilerplate code, that can be easily customized to configure Container Optimized OS instances.

The following resources are created and managed by this module:

* `google_compute_address`, one reserved IP address per instance
* `google_compute_instance`, one or more COS instances
* `google_compute_firewall`, one firewall rule to allow traffic from specific IP ranges to the DNS port

Variables allow controlling several aspects of the created resurces, like number of instances (`instance_count`), the container image used for CoreDNS (`container_image`), the client IP ranges (`client_cidrs`), the cloud config file passed to the instance (`cloud-init`).

## Sample Usage

This is a sample module invocation:

```hcl
module "simple-gcs-copier" {
  source                = "terraform-google-modules/container-vm/google//modules/cos-generic"
  instance_count        = "1"
  project_id            = "my-project"
  region                = "europe-west3"
  zone                  = "europe-west3-c"
  prefix                = "gcs-copier"
  vm_tags               = ["ssh"]
  cloud_init            = "cloud-config.yaml"
  cloud_init_custom_var = "mybucket,*:0/1"
  subnetwork            = "https://www.googleapis.com/compute/v1/projects/my-project/regions/europe-west3/subnetworks/my-subnetwork"
}
```

And an example cloud config file to implement a basic scheduled copy:

```yml
#cloud-config

write_files:
- path: /var/lib/docker/daemon.json
  permissions: 0644
  owner: root
  content: |
    {
      "live-restore": true,
      "storage-driver": "overlay2",
      "log-opts": {
        "max-size": "1024m"
      }
    }
# Gsutil systemd unit
- path: /etc/systemd/system/gcs-sync.service
  permissions: 0644
  owner: root
  content: |
    [Unit]
    Description=Syncs a GCS bucket locally
    [Service]
    Type=oneshot
    ExecStart=/usr/bin/docker run --rm \
      --name=gcs-sync --log-driver=gcplogs --log-opt gcp-log-cmd=true \
      gcr.io/cloud-builders/gsutil rsync \
      gs://dataflow-samples/shakespeare \
      gs://${element(split(",", custom_var), 0)}
# add a second ExecStart to chain a command (eg launch a pipeline)
# Gsutil systemd timer
- path: /etc/systemd/system/gcs-sync.timer
  permissions: 0644
  owner: root
  content: |
    [Unit]
    Description=Run gcs-sync.service periodically
    [Timer]
    OnCalendar=${element(split(",", custom_var), 1)}
    [Install]
    WantedBy=multi-user.target
runcmd:
- iptables -I INPUT 1 -p tcp -m tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
- systemctl daemon-reload
- systemctl enable gcs-sync.service && systemctl start gcs-sync.service
- systemctl enable gcs-sync.timer && systemctl start gcs-sync.timer
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| allow\_stopping\_for\_update | Allow stopping the instance for specific Terraform changes. | bool | `"false"` | no |
| boot\_disk\_size | Size of the boot disk. | number | `"10"` | no |
| cloud\_init | Path to a file that will be used for the cloud-config template. | string | `""` | no |
| cloud\_init\_custom\_var | String passed in to the cloud-config template as custome variable. | string | `""` | no |
| instance\_count | Number of instances to create. | number | `"1"` | no |
| instance\_type | Instance machine type. | string | `"g1-small"` | no |
| labels | Labels to be attached to the resources | map(string) | `<map>` | no |
| prefix | Prefix to prepend to resource names. | string | `""` | no |
| project\_id | Project id where the instances will be created. | string | n/a | yes |
| region | Region for external addresses. | string | n/a | yes |
| reserve\_ip | Reserve an IP address for the instance instead of using an ephemeral address. | bool | `"false"` | no |
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
| internal\_addresses | List of instance internal addresses. |
| names | List of instance names. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

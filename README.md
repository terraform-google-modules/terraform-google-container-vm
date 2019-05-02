# Terraform Google Container VM Metadata Module

This module handles the generation of metadata for [deploying containers on GCE instances](https://cloud.google.com/compute/docs/containers/deploying-containers).

This module itself does not launch an instance or managed instance group. It simply generates the necessary metadata to create an instance or MIG yourself. Examples of using this module can be found in the [examples/](examples) directory.

## Usage

```hcl
module "gce-container" {
  source = "github.com/terraform-google-modules/terraform-google-container-vm"
  version = "0.1.0"

  container = {
    image="gcr.io/google-samples/hello-app:1.0"
    env = [
      {
        name = "TEST_VAR"
        value = "Hello World!"
      }
    ],
    volumeMounts = [
      {
        mountPath = "/cache"
        name      = "tempfs-0"
        readOnly  = "false"
      },
      {
        mountPath = "/persistent-data"
        name      = "data-disk-0"
        readOnly  = "false"
      },
    ]
  }

  volumes = [
    {
      name = "tempfs-0"

      emptyDir = {
        medium = "Memory"
      }
    },
    {
      name = "data-disk-0"

      gcePersistentDisk = {
        pdName = "data-disk-0"
        fsType = "ext4"
      }
    },
  ]

  restart_policy = "Always"
}
```

Then perform the following commands on the root folder:

- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
[^]: (autogen_docs_start)


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| container | A description of the container to deploy | map | `<map>` | no |
| restart_policy | The restart policy for a Docker container. Defaults to `OnFailure` | string | `OnFailure` | no |
| volumes | A set of Docker Volumes to configure | list | `<list>` | no |

## Outputs

| Name | Description |
|------|-------------|
| container | The container definition provided |
| metadata_key | The key to assign `metadata_value` to, so container information is attached to the instance |
| metadata_value | The generated container configuration |
| restart_policy | The restart policy provided |
| source_image | The COS image to use for the GCE instance |
| vm_container_label | The COS version to deploy to the instance. To be used as the value for the `vm_container_label_key` label key |
| vm_container_label_key | The label key for the COS version deployed to the instance |
| volumes | The volume definition provided |

[^]: (autogen_docs_end)

## Requirements
### Terraform plugins
- [Terraform](https://www.terraform.io/downloads.html) 0.10.x
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) plugin v1.8.0

### Python Libraries
- [terraform_external_data](https://github.com/operatingops/terraform_external_data)

### Configure a Service Account
In order to execute this module you must have a Service Account with the following:

#### Permissions
- `compute.disks.*` on the project
- `compute.diskTypes.get` on the project
- `compute.diskTypes.list` on the project

### Enable API's
In order to operate with the Service Account you must activate the following APIs on the project where the Service Account was created:

- Compute Engine API - compute.googleapis.com

## Install

### Terraform
Be sure you have the correct Terraform version (0.10.x), you can choose the binary here:
- https://releases.hashicorp.com/terraform/

## File structure
The project has the following folders and files:

- /: root folder
- /build: Dockerfiles and other build manifests
- /examples: Examples for using this module
- /helpers: Scripts that the module invokes
- /test: Folders with files for testing the module (see Testing section of this file)
- /main.tf: main file for this module, contains all the resources to create
- /variables.tf: all the variables for the module
- /output.tf: the outputs of the module
- /readme.md: this file

## Testing

### Requirements
- [docker](https://www.docker.com/)
- [terraform-docs](https://github.com/segmentio/terraform-docs/releases) 0.3.0

### Autogeneration of documentation from .tf files
Run
```
make generate_docs
```

### Integration test

#### Terraform integration tests
The integration tests for this module leverage [kitchen-terraform](https://github.com/newcontext-oss/kitchen-terraform) and [kitchen-inspec](https://github.com/inspec/kitchen-inspec), and run entirely within `docker` containers.

The tests will do the following:
- Perform `bundle install` command
  - Installs `kitchen-terraform` and `kitchen-inspec` gems
- Perform `kitchen create` command
  - Performs a `terraform init`
- Perform `kitchen converge` command
  - Performs a `terraform apply -auto-approve`
- Perform `kitchen validate` command
  - Performs inspec tests.
    - Shell out to `gcloud` to validate expected resources in GCP.
    - Log into deployed resources to validate Docker configuration.
    - Make HTTP requests to endpoints that are expected to be online.
- Perform `kitchen destroy` command
  - Performs a `terraform destroy -force`

Before running integration tests, you need to configure `terraform.tfvars` for your particular environment by running `cp test/fixtures/shared/terraform.tfvars.sample test/fixtures/shared/terraform.tfvars` and editing `test/fixtures/shared/terraform.tfvars` to reflect your testing environment.

You can then use the following command to run the integration test in the root folder

  `make test_integration_docker`

### Linting
The makefile in this project will lint or sometimes just format any shell,
Python, golang, Terraform, or Dockerfiles. The linters will only be run if
the makefile finds files with the appropriate file extension.

All of the linter checks are in the default make target, so you just have to
run

```
make -s
```

The -s is for 'silent'. Successful output looks like this

```
Running shellcheck
Running flake8
Running go fmt and go vet
Running terraform validate
Running terraform fmt
Running hadolint on Dockerfiles
Checking for required files
Testing the validity of the header check
..
----------------------------------------------------------------------
Ran 2 tests in 0.024s

OK
Checking file headers
The following lines have trailing whitespace
Generating markdown docs with terraform-docs
```

The linters are as follows:
* Shell - shellcheck. Can be found in homebrew
* Python - flake8. Can be installed with 'pip install flake8'
* Golang - gofmt. gofmt comes with the standard golang installation. golang is a compiled language so there is no standard linter.
* Terraform - terraform has a built-in linter in the 'terraform fmt' command.
* Dockerfiles - hadolint. Can be found in homebrew
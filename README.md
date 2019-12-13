# Terraform Google Container VM Metadata Module

This module handles the generation of metadata for [deploying containers on GCE instances](https://cloud.google.com/compute/docs/containers/deploying-containers).

This module itself does not launch an instance or managed instance group. It simply generates the necessary metadata to create an instance or MIG yourself. Examples of using this module can be found in the [examples/](examples) directory.

## Compatibility

This module is meant for use with Terraform 0.12. If you need a Terraform 0.11.x-compatible version of this module, the last released version intended for Terraform 0.11.x is [0.3.0].

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

    # Declare volumes to be mounted.
    # This is similar to how docker volumes are declared.
    volumeMounts = [
      {
        mountPath = "/cache"
        name      = "tempfs-0"
        readOnly  = false
      },
      {
        mountPath = "/persistent-data"
        name      = "data-disk-0"
        readOnly  = false
      },
    ]
  }

  # Declare the Volumes which will be used for mounting.
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
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| container | A description of the container to deploy | any | `<map>` | no |
| cos\_image\_family | The COS image family to use (eg: stable, beta, or dev) | string | `"stable"` | no |
| cos\_image\_name | Name of a specific COS image to use instead of the latest cos family image | string | `"null"` | no |
| restart\_policy | The restart policy for a Docker container. Defaults to `OnFailure` | string | `"OnFailure"` | no |
| volumes | A set of Docker Volumes to configure | any | `<list>` | no |

## Outputs

| Name | Description |
|------|-------------|
| container | The container definition provided |
| metadata\_key | The key to assign `metadata_value` to, so container information is attached to the instance |
| metadata\_value | The generated container configuration |
| restart\_policy | The restart policy provided |
| source\_image | The COS image to use for the GCE instance |
| vm\_container\_label | The COS version to deploy to the instance. To be used as the value for the `vm_container_label_key` label key |
| vm\_container\_label\_key | The label key for the COS version deployed to the instance |
| volumes | The volume definition provided |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

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

Before running integration tests, you need to configure `terraform.tfvars` for your particular environment editing `test/fixtures/shared/terraform.tfvars` to reflect your testing environment.

You can then use the following command to run the integration test in the root folder

  `make test_integration_docker`

### Linting
The makefile in this project will lint or sometimes just format any shell,
Python, golang, Terraform. The linters will only be run if
the makefile finds files with the appropriate file extension.

All of the linter checks are in the default make target, so you just have to
run

```
make -s
```

The -s is for 'silent'. Successful output looks like below and exists with 0 exit code.

```
$ make -s
Running shellcheck
Running flake8
Running go fmt and go vet
Running terraform fmt
terraform fmt -diff -check=true -write=false .
terraform fmt -diff -check=true -write=false ./examples/instance_with_attached_disk
terraform fmt -diff -check=true -write=false ./examples/simple_instance
terraform fmt -diff -check=true -write=false ./modules/cos-coredns
terraform fmt -diff -check=true -write=false ./modules/cos-generic
terraform fmt -diff -check=true -write=false ./modules/cos-mysql
terraform fmt -diff -check=true -write=false ./test/fixtures/instance_with_attached_disk
terraform fmt -diff -check=true -write=false ./test/fixtures/shared
terraform fmt -diff -check=true -write=false ./test/fixtures/simple_instance
Running terraform validate
helpers/terraform_validate .

Initializing provider plugins...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.external: version = "~> 1.2"
* provider.google: version = "~> 2.12"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
Success! The configuration is valid.

helpers/terraform_validate ./examples/instance_with_attached_disk
Initializing modules...

Initializing provider plugins...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.external: version = "~> 1.2"
* provider.google: version = "~> 2.12"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
Success! The configuration is valid.

helpers/terraform_validate ./examples/simple_instance
Initializing modules...

Initializing provider plugins...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.external: version = "~> 1.2"
* provider.google: version = "~> 2.12"
* provider.random: version = "~> 2.2"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
Success! The configuration is valid.

helpers/terraform_validate ./modules/cos-coredns

Initializing provider plugins...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.google: version = "~> 2.12"
* provider.template: version = "~> 2.1"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
Success! The configuration is valid.

helpers/terraform_validate ./modules/cos-generic

Initializing provider plugins...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.google: version = "~> 2.12"
* provider.template: version = "~> 2.1"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
Success! The configuration is valid.

helpers/terraform_validate ./modules/cos-mysql

Initializing provider plugins...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.google: version = "~> 2.12"
* provider.random: version = "~> 2.2"
* provider.template: version = "~> 2.1"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
Success! The configuration is valid.

helpers/terraform_validate ./test/fixtures/instance_with_attached_disk
Initializing modules...

Initializing provider plugins...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.external: version = "~> 1.2"
* provider.google: version = "~> 2.12"
* provider.local: version = "~> 1.3"
* provider.random: version = "~> 2.2"
* provider.tls: version = "~> 2.0"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
Success! The configuration is valid.

helpers/terraform_validate ./test/fixtures/simple_instance
Initializing modules...

Initializing provider plugins...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.external: version = "~> 1.2"
* provider.google: version = "~> 2.12"
* provider.random: version = "~> 2.2"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
Success! The configuration is valid.

Checking for required files LICENSE README.md
Testing the validity of the header check
..
----------------------------------------------------------------------
Ran 2 tests in 0.014s

OK
Checking file headers
Checking for trailing whitespace
Generating markdown docs with terraform-docs
Skipping ./test/fixtures/instance_with_attached_disk because README.md does not exist.
Skipping ./test/fixtures/shared because README.md does not exist.
Skipping ./test/fixtures/simple_instance because README.md does not exist.
$ echo $?
0
```

The linters are as follows:
* Shell - shellcheck. Can be found in homebrew
* Python - flake8. Can be installed with 'pip install flake8'
* Golang - gofmt. gofmt comes with the standard golang installation. golang is a compiled language so there is no standard linter.
* Terraform (built-in):
  - `terraform fmt`
  - `terraform validate`.
* File headers
* Trailing whitespaces

## Known limitations
Managed instance group [example](examples/managed_instance_group/main.tf) is not migrated to Terraform 0.12
This is tracked as issue [`#28`](https://github.com/terraform-google-modules/terraform-google-container-vm/issues/28)
Linters and integrations tests skip this example and associated tests for now.

[0.3.0]: https://registry.terraform.io/modules/terraform-google-modules/container-vm/google/0.3.0

locals {
	coreos_image_family = "cos-stable"
	coreos_project = "cos-cloud"
	invalid_restart_policy = "${var.restart_policy != "OnFailure" && var.restart_policy != "UnlessStopped" && var.restart_policy != "Always" && var.restart_policy != "No" ? 1 : 0}"
	spec = {
		spec = {
			containers = "${var.containers}"
			volumes = "${var.volumes}"
			restartPolicy = "${var.restart_policy}"
		}
	}
}

data "google_compute_image" "coreos" {
	family = "${local.coreos_image_family}"
	project = "${local.coreos_project}"
}

resource "null_resource" "validate_restart_policy" {
	count = "${local.invalid_restart_policy}"
	"ERROR: Invalid `restart_policy` ${var.restart_policy} was provided. Must be one of `OnFailure`, `UnlessStopped`, `Always`, or `No`" = true
}

data "external" "spec_as_yaml" {
	program = ["ruby", "${path.module}/helpers/map_to_yaml.rb"]

	query = {
		root = "${jsonencode(local.spec)}"
	}
}

output "project_id" {
  value = "${var.project_id}"
}

output "subnetwork_project" {
  value = "${var.subnetwork_project}"
}

output "subnetwork" {
  value = "${var.subnetwork}"
}

output "credentials_path" {
  value = "${var.credentials_path}"
}

output "instance_name" {
  value = "${var.instance_name}"
}

output "image" {
  value = "${var.image}"
}

output "restart_policy" {
	value = "${var.restart_policy}"
}

output "machine_type" {
  value = "${var.machine_type}"
}

output "region" {
  value = "${var.region}"
}

output "zone" {
  value = "${var.zone}"
}

output "ipv4" {
  value = "${google_compute_instance.vm.network_interface.0.access_config.0.assigned_nat_ip }"
}

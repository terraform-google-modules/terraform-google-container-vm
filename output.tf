output "metadata_key" {
	value = "gce-container-declaration"
}

output "metadata_value" {
	value = "${data.template_file.konlet.rendered}"
}

output "source_image" {
	value = "${data.google_compute_image.coreos.self_link}"
}

output "vm_container_label_key" {
	value = "container-vm"
}

output "vm_container_label" {
	value = "cos-stable-63-10032-88-0" // TODO can this be fetched dynamically?
}

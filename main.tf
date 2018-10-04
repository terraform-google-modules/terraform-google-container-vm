locals {
	coreos_image_family = "cos-stable"
	coreos_project = "cos-cloud"
}

data "google_compute_image" "coreos" {
	family = "${local.coreos_image_family}"
	project = "${local.coreos_project}"
}

data "template_file" "konlet" {
	# TODO get from variables!
	template = <<EOF
spec:
	containers:
	- name: busybox-vm
		image: gcr.io/google-containers/busybox
		command:
		- ls
		args:
		- '-l'
		stdin: true
		tty: true
		securityContext:
			privileged: true
		env:
		- name: TEST_1
			value: "Hello world"
		volumeMounts:
		- mountPath: /cache
			name: tempfs-0
		- mountPath: /tmp-host
			name: host-path-0
		- mountPath: /persistent-data
			name: data-disk-0
			readOnly: false
	volumes:
	- name: tmpfs-0
		emptyDir:
			medium: "Memory"
	- name: host-path-0
		hostPath:
			path: "/tmp"
	- name: data-disk-0
		gcePersistentDisk:
			pdName: "data-disk"
			fsType: ext4
	restartPolicy: OnFailure
EOF

	vars {

	}
}

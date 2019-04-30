/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

provider "google" {
  region = "${var.region}"
}

module "gce-container" {
  source = "../../"

  container = {
    image = "${var.image}"

    env = [
      {
        name = "TEST_VAR"
        value = "Hello World!"
      }
    ]

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

  restart_policy = "${var.restart_policy}"
}

resource "google_compute_disk" "pd" {
  project = "${var.project_id}"
  name    = "${var.instance_name}-data-disk"
  type    = "pd-ssd"
  zone    = "${var.zone}"
  size    = 10
}

resource "google_compute_instance" "vm" {
  project      = "${var.project_id}"
  name         = "${var.instance_name}"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"

  boot_disk {
    initialize_params {
      image = "${module.gce-container.source_image}"
    }
  }

  attached_disk {
    source      = "${google_compute_disk.pd.self_link}"
    device_name = "data-disk-0"
    mode        = "READ_WRITE"
  }

  network_interface {
    subnetwork_project = "${var.subnetwork_project}"
    subnetwork         = "${var.subnetwork}"
    access_config      = {}
  }

  metadata = "${merge(var.additional_metadata, map("gce-container-declaration", module.gce-container.metadata_value))}"

  labels {
    "container-vm" = "${module.gce-container.vm_container_label}"
  }

  tags = ["container-vm-example", "container-vm-test-disk-instance"]

  service_account {
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}

resource "google_compute_firewall" "http-access" {
  name    = "${var.instance_name}-http"
  project = "${var.project_id}"
  network = "${var.subnetwork}"

  allow {
    protocol = "tcp"
    ports    = ["${var.image_port}"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["container-vm-test-disk-instance"]
}

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

data "google_compute_zones" "available" {
  project = "${var.project_id}"
  region  = "${var.region}"
}

resource "random_shuffle" "zone" {
  input        = ["${data.google_compute_zones.available.names}"]
  result_count = 1
}

module "gce-container" {
  source = "../../"

  container = {
    image = "gcr.io/google-samples/hello-app:1.0"

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
      }
    ]

  }

  volumes = [
    {
      name = "tempfs-0"

      emptyDir = {
        medium = "Memory"
      }
    },
  ]

  restart_policy = "Always"
}

resource "google_compute_instance" "vm" {
  project      = "${var.project_id}"
  name         = "${var.instance_name}"
  machine_type = "n1-standard-1"
  zone         = "${random_shuffle.zone.result[0]}"

  boot_disk {
    initialize_params {
      image = "${module.gce-container.source_image}"
    }
  }

  network_interface {
    subnetwork_project = "${var.subnetwork_project}"
    subnetwork         = "${var.subnetwork}"
    access_config      = {}
  }

  tags = ["container-vm-example"]

  metadata {
    "gce-container-declaration" = "${module.gce-container.metadata_value}"
  }

  labels {
    "container-vm" = "${module.gce-container.vm_container_label}"
  }

  service_account {
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}

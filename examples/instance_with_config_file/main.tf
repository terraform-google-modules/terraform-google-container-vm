/**
 * Copyright 2020 Google LLC
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
  project = var.project_id
  version = "~> 3.53"
}

provider "template" {
  version = "~> 2.1"
}

locals {
  instance_name = format("%s-%s", var.instance_name, substr(md5(module.gce-container.container.image), 0, 8))
  config_path   = "/etc/hello-app/config.json"
}

module "gce-container" {
  source = "../../"

  cos_image_name = var.cos_image_name

  container = {
    image = "gcr.io/google-samples/hello-app:1.0"

    volumeMounts = [
      {
        mountPath = "/config.json"
        name      = "config"
        readOnly  = true
      },
    ]
  }

  volumes = [
    {
      name = "config"
      hostPath = {
        path = local.config_path
      }
    },
  ]

  restart_policy = "Always"
}

data "template_file" "startup_script" {
  template = "${file("${path.module}/startup.sh.tpl")}"
  vars = {
    instance_name = local.instance_name
    config_path   = local.config_path
  }
}

resource "google_compute_instance" "vm" {
  project      = var.project_id
  name         = local.instance_name
  machine_type = "n1-standard-1"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = module.gce-container.source_image
    }
  }

  network_interface {
    subnetwork_project = var.subnetwork_project
    subnetwork         = var.subnetwork
    access_config {}
  }

  tags = ["container-vm-example"]

  metadata = merge(
    {
      gce-container-declaration = module.gce-container.metadata_value
      google-logging-enabled    = "true"
      google-monitoring-enabled = "true"
    },
    var.additional_metadata,
  )

  labels = {
    container-vm = module.gce-container.vm_container_label
  }

  service_account {
    email = var.client_email
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  metadata_startup_script = data.template_file.startup_script.rendered
}

/**
 * Copyright 2019 Google LLC
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

locals {
  instance_name = format("%s-%s", var.instance_name, substr(md5(module.gce-advanced-container.container.image), 0, 8))
}

module "gce-advanced-container" {
  source  = "terraform-google-modules/container-vm/google"
  version = "~> 3.0"

  container = {
    image = "busybox"
    command = [
      "tail"
    ]
    args = [
      "-f",
      "/dev/null"
    ]
    securityContext = {
      privileged : true
    }
    tty : true
    env = [
      {
        name  = "EXAMPLE"
        value = "VAR"
      }
    ]
  }

  restart_policy = "OnFailure"
}

resource "google_compute_instance" "vm" {
  project      = var.project_id
  name         = local.instance_name
  machine_type = "n1-standard-1"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = module.gce-advanced-container.source_image
    }
  }

  network_interface {
    subnetwork_project = var.subnetwork_project
    subnetwork         = var.subnetwork
    access_config {}
  }

  tags = ["container-vm-example"]

  metadata = {
    gce-container-declaration = module.gce-advanced-container.metadata_value
  }

  labels = {
    container-vm = module.gce-advanced-container.vm_container_label
  }

  service_account {
    email = var.client_email
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}

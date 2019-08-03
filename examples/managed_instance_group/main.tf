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

locals {
  google_load_balancer_ip_ranges = [
    "130.211.0.0/22",
    "35.191.0.0/16",
  ]
}

provider "google" {
  region = var.region
}

module "gce-container" {
  source = "../../"

  container = {
    image = var.image
  }
}

module "mig" {
  source             = "GoogleCloudPlatform/managed-instance-group/google"
  version            = "1.1.14"
  project            = var.project_id
  region             = var.region
  zone               = var.zone
  name               = var.mig_name
  machine_type       = var.machine_type
  compute_image      = module.gce-container.source_image
  size               = var.mig_instance_count
  service_port       = var.image_port
  service_port_name  = "http"
  http_health_check  = "true"
  subnetwork         = var.subnetwork
  subnetwork_project = var.subnetwork_project
  ssh_source_ranges  = ["0.0.0.0/0"]
  target_tags        = ["container-vm-test-mig"]

  metadata = merge(var.additional_metadata, map("gce-container-declaration", module.gce-container.metadata_value))

  instance_labels = {
    "container-vm" = module.gce-container.vm_container_label
  }

  service_account_scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
  ]

  wait_for_instances = true
}

module "http-lb" {
  source            = "github.com/GoogleCloudPlatform/terraform-google-lb-http"
  project           = var.project_id
  name              = "${var.mig_name}-lb"
  firewall_networks = []
  target_tags       = [module.mig.target_tags]

  backends = {
    "0" = [
      {
        group = module.mig.instance_group
      },
    ]
  }

  backend_params = [
    "/,http,${var.image_port},30",
  ]
}

resource "google_compute_firewall" "lb-to-instances" {
  name    = "${var.mig_name}-firewall-lb-to-instances"
  project = var.project_id
  network = var.subnetwork

  allow {
    protocol = "tcp"
    ports    = [var.image_port]
  }

  source_ranges = [local.google_load_balancer_ip_ranges]
  target_tags   = [module.mig.target_tags]
}

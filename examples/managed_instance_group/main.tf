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
  target_tags = [
    "container-vm-test-mig"
  ]
}
provider "google" {
  project = var.project_id
  version = "~> 2.7.0"
}
provider "google-beta" {
  project = var.project_id
  version = "~> 2.7.0"
}
module "gce-container" {
  source = "../../"
  container = {
    image = var.image
  }
}
resource "google_compute_network" "default" {
  name                    = var.network
  auto_create_subnetworks = "false"
}
resource "google_compute_subnetwork" "default" {
  name                     = var.subnetwork
  ip_cidr_range            = "10.125.0.0/20"
  network                  = google_compute_network.default.self_link
  region                   = var.region
  private_ip_google_access = true
}
# Router and Cloud NAT are required for installing packages from repos (apache, php etc)
resource "google_compute_router" "default" {
  name    = "${var.network}-gw-group1"
  network = google_compute_network.default.self_link
  region  = var.region
}
module "cloud-nat" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "~> 1.0.0"
  router     = google_compute_router.default.name
  project_id = var.project_id
  region     = var.region
  name       = "${var.network}-cloud-nat-group1"
}
module "mig_template" {
  source               = "terraform-google-modules/vm/google//modules/instance_template"
  version              = "~> 1.0.0"
  network              = google_compute_network.default.self_link
  subnetwork           = google_compute_subnetwork.default.self_link
  service_account      = var.service_account
  name_prefix          = var.network
  source_image_family  = "cos-stable"
  source_image_project = "cos-cloud"
  source_image         = reverse(split("/", module.gce-container.source_image))[0]
  metadata             = merge(var.additional_metadata, map("gce-container-declaration", module.gce-container.metadata_value))
  tags = [
    "container-vm-test-mig"
  ]
  labels = {
    "container-vm" = module.gce-container.vm_container_label
  }
}
module "mig" {
  source            = "terraform-google-modules/vm/google//modules/mig"
  version           = "~> 1.0.0"
  instance_template = module.mig_template.self_link
  region            = var.region
  hostname          = var.network
  target_size       = var.mig_instance_count
  named_ports = [
    {
      name = "http",
      port = var.image_port
    }
  ]
  network    = google_compute_network.default.self_link
  subnetwork = var.subnetwork
}
module "http-lb" {
  source  = "GoogleCloudPlatform/lb-http/google"
  version = "~> 2.0"

  project = var.project_id
  name    = "${var.mig_name}-lb"
  firewall_networks = [
    google_compute_network.default.self_link
  ]
  target_tags = local.target_tags
  backends = {
    "0" = [
      {
        group                        = module.mig.instance_group
        balancing_mode               = null
        capacity_scaler              = null
        description                  = null
        max_connections              = null
        max_connections_per_instance = null
        max_rate                     = null
        max_rate_per_instance        = null
        max_utilization              = null
      }
    ]
  }
  backend_params = [
    "/,http,${var.image_port},30",
  ]
}
resource "google_compute_firewall" "lb-to-instances" {
  name    = "${var.mig_name}-firewall-lb-to-instances"
  project = var.project_id
  network = var.network
  allow {
    protocol = "tcp"
    ports = [
      var.image_port
    ]
  }
  source_ranges = local.google_load_balancer_ip_ranges
  target_tags   = local.target_tags
}

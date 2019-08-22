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
  cloud_init = var.cloud_init != "" ? var.cloud_init : "${path.module}/assets/cloud-config.yaml"
  prefix     = var.prefix == "" ? "" : "${var.prefix}-"
}

resource "google_compute_address" "addresses" {
  count        = var.instance_count
  project      = var.project_id
  name         = "${local.prefix}${format("%d", count.index + 1)}"
  region       = var.region
  subnetwork   = var.subnetwork
  address_type = "INTERNAL"

  # the google-beta provider is needed for labels
  # labels = var.labels
}

data "template_file" "cloud-config" {
  count    = var.instance_count
  template = file(local.cloud_init)

  vars = {
    custom_var    = var.cloud_init_custom_var
    instance_id   = count.index + 1
    instance_name = "${local.prefix}${count.index + 1}"
    ip_address    = var.reserve_ip ? google_compute_address.addresses.*.address[count.index] : ""
  }
}

resource "google_compute_instance" "default" {
  count          = var.instance_count
  name           = "${local.prefix}${count.index + 1}"
  description    = "Terraform-managed."
  tags           = var.vm_tags
  labels         = var.labels
  machine_type   = var.instance_type
  project        = var.project_id
  zone           = var.zone
  can_ip_forward = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  boot_disk {
    initialize_params {
      type  = "pd-standard"
      image = "projects/cos-cloud/global/images/family/cos-stable"
      size  = var.boot_disk_size
    }
  }

  network_interface {
    subnetwork = var.subnetwork
    network_ip = var.reserve_ip ? google_compute_address.addresses.*.address[count.index] : ""
    access_config {}
  }

  service_account {
    email  = var.service_account
    scopes = var.scopes
  }

  metadata = {
    google-logging-enabled    = var.stackdriver_logging
    google-monitoring-enabled = var.stackdriver_monitoring
    user-data                 = data.template_file.cloud-config.*.rendered[count.index]
  }

  allow_stopping_for_update = var.allow_stopping_for_update
}

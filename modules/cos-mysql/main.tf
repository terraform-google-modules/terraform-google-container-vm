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
  net_project_id = var.host_project_id != "" ? var.host_project_id : var.project_id
  password       = var.password != "" ? var.password : random_id.password.b64_url
  prefix         = var.prefix == "" ? "" : "${var.prefix}-"
  use_kms        = var.password != "" && length(var.kms_data) == 4
}

# optional resources

resource "random_id" "password" {
  byte_length = 8
}

resource "google_compute_address" "addresses" {
  count        = var.instance_count
  project      = var.project_id
  name         = "${local.prefix}mysql-${format("%d", count.index + 1)}"
  region       = var.region
  subnetwork   = var.subnetwork
  address_type = "INTERNAL"

  # the google-beta provider is needed for labels
  # labels = var.labels
}

data "template_file" "cloud-config" {
  count    = var.instance_count
  template = file("${path.module}/assets/cloud-config.yaml")

  vars = {
    image       = var.container_image
    instance_id = count.index + 1
    ip_address  = google_compute_address.addresses.*.address[count.index]
    key         = lookup(var.kms_data, "key", "")
    keyring     = lookup(var.kms_data, "keyring", "")
    location    = lookup(var.kms_data, "location", "")
    log_driver  = var.log_driver
    password    = local.password
    port        = var.mysql_port
    project_id  = lookup(var.kms_data, "project_id", "")
    use_kms     = local.use_kms

    my_cnf = var.my_cnf == "" ? file("${path.module}/assets/my.cnf") : var.my_cnf
  }
}

resource "google_compute_disk" "disk-data" {
  count   = var.instance_count
  name    = "${local.prefix}mysql-data-${count.index + 1}"
  type    = var.data_disk_type
  project = var.project_id
  zone    = var.zone
  size    = var.data_disk_size
  labels  = var.labels
}

resource "google_compute_instance" "default" {
  count                     = var.instance_count
  name                      = "${local.prefix}mysql-${count.index + 1}"
  description               = "MySQL test with containers on CoS."
  tags                      = concat(list(var.network_tag), var.vm_tags)
  labels                    = var.labels
  machine_type              = var.instance_type
  project                   = var.project_id
  zone                      = var.zone
  can_ip_forward            = false
  allow_stopping_for_update = true

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
    network_ip = google_compute_address.addresses.*.address[count.index]
    access_config {}
  }

  attached_disk {
    source      = google_compute_disk.disk-data.*.name[count.index]
    device_name = "mysql-data"
  }

  service_account {
    email = var.service_account

    scopes = compact(concat(
      var.scopes,
      list(local.use_kms ? "https://www.googleapis.com/auth/cloudkms" : "")
    ))
  }

  metadata = {
    user-data                 = data.template_file.cloud-config.*.rendered[count.index]
    google-logging-enabled    = var.stackdriver_logging
    google-monitoring-enabled = var.stackdriver_monitoring
  }
}

# TODO(ludomagno): split in service and client rules
resource "google_compute_firewall" "allow-tag-mysql" {
  count       = var.create_firewall_rule ? 1 : 0
  name        = "${local.prefix}ingress-tag-mysql"
  description = "Allow ingress to MySQL ports to machines with the 'mysql' tag"

  network = var.network
  project = local.net_project_id

  source_ranges = var.client_cidrs
  target_tags   = ["mysql"]

  allow {
    protocol = "tcp"
    ports    = [var.mysql_port]
  }
}

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

resource "random_string" "suffix" {
  length  = 4
  upper   = "false"
  lower   = "true"
  number  = "false"
  special = "false"
}

resource "google_compute_network" "main" {
  name                    = "cft-container-vm-test-${local.example_name}-${random_string.suffix.result}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "main" {
  name          = "cft-container-vm-test-${local.example_name}-${random_string.suffix.result}"
  ip_cidr_range = "10.0.0.0/22"
  region        = module.example.region
  network       = google_compute_network.main.self_link
}

resource "google_compute_firewall" "ssh" {
  name    = "cft-test-${random_string.suffix.result}-${local.example_name}-ssh"
  project = var.project_id
  network = google_compute_subnetwork.main.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["container-vm-example"]
}

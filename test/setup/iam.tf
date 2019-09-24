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
  container_vm_required_roles = [
    "roles/owner",
    "roles/editor",
    "roles/compute.admin",
    "roles/compute.networkAdmin",
    "roles/compute.instanceAdmin.v1",
    "roles/iam.serviceAccountUser",
  ]
}

resource "google_service_account" "container_vm" {
  project      = module.container_vm.project_id
  account_id   = "ci-container-vm"
  display_name = "ci-container-vm"
}

resource "google_service_account_key" "container_vm" {
  service_account_id = google_service_account.container_vm.id
}

resource "google_project_iam_member" "container_vm" {
  count = length(local.container_vm_required_roles)

  project = module.container_vm.project_id
  role    = local.container_vm_required_roles[count.index]
  member  = "serviceAccount:${google_service_account.container_vm.email}"
}

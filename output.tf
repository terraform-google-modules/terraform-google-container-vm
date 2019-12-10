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

output "metadata_key" {
  description = "The key to assign `metadata_value` to, so container information is attached to the instance"
  value       = "gce-container-declaration"
}

output "metadata_value" {
  description = "The generated container configuration"
  value       = local.spec_as_yaml
}

output "source_image" {
  description = "The COS image to use for the GCE instance"
  value       = data.google_compute_image.coreos.self_link
}

output "vm_container_label_key" {
  description = "The label key for the COS version deployed to the instance"
  value       = "container-vm"
}

output "vm_container_label" {
  description = "The COS version to deploy to the instance. To be used as the value for the `vm_container_label_key` label key"
  value       = data.google_compute_image.coreos.name
}

output "container" {
  description = "The container definition provided"
  value       = var.container
}

output "volumes" {
  description = "The volume definition provided"
  value       = var.volumes
}

output "restart_policy" {
  description = "The restart policy provided"
  value       = var.restart_policy
}

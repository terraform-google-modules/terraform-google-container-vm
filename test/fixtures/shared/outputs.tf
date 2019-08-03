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

output "project_id" {
  description = "The GCP project ID that resources were deployed into"
  value       = var.project_id
}

output "zone" {
  description = "The GCP zone that resources were deployed into"
  value       = module.example.zone
}

output "network" {
  description = "The name of the GCP network that resources were deployed into"
  value       = google_compute_network.main.name
}

output "subnetwork" {
  description = "The name of the GCP subnetwork that resources were deployed into"
  value       = google_compute_subnetwork.main.name
}

output "vm_container_label" {
  description = "The label containing container configuration"
  value       = module.example.vm_container_label
}

output "container" {
  description = "The configured Docker container"
  value       = module.example.container
}

output "volumes" {
  description = "The configured Docker volumes"
  value       = module.example.volumes
}

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
  description = "The project ID resources were deployed into"
  value       = var.project_id
}

output "vm_container_label" {
  description = "The instance label containing container configuration"
  value       = module.gce-container.vm_container_label
}

output "container" {
  description = "The container metadata provided to the module"
  value       = module.gce-container.container
}

output "volumes" {
  description = "The volume metadata provided to the module"
  value       = module.gce-container.volumes
}

output "http_address" {
  description = "The IP address on which the HTTP service is exposed"
  value       = module.http-lb.external_ip
}

output "http_port" {
  description = "The port on which the HTTP service is exposed"
  value       = "80"
}

output "region" {
  description = "The region the GCE instance was deployed into"
  value       = var.region
}

output "zone" {
  description = "The zone the GCE instance was deployed into"
  value       = var.zone
}

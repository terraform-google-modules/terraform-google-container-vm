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

variable "project_id" {
  description = "The project ID to deploy resource into"
}

variable "subnetwork_project" {
  description = "The project ID where the desired subnetwork is provisioned"
}

variable "subnetwork" {
  description = "The name of the subnetwork to deploy instances into"
}

variable "instance_name" {
  description = "The desired name to assign to the deployed instance"
  default     = "disk-instance-vm-test"
}

variable "image" {
  description = "The Docker image to deploy to GCE instances"
}

variable "image_port" {
  description = "The port the image exposes for HTTP requests"
}

variable "restart_policy" {
  description = "The desired Docker restart policy for the deployed image"
}

variable "machine_type" {
  description = "The GCP machine type to deploy"
}

variable "zone" {
  description = "The GCP zone to deploy instances into"
}

variable "additional_metadata" {
  type        = map(string)
  description = "Additional metadata to attach to the instance"
  default     = {}
}

variable "client_email" {
  description = "Service account email address"
  type        = string
  default     = ""
}

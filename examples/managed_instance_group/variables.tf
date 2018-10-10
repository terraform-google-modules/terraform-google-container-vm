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

variable "credentials_path" {
  description = "The path to a valid service account JSON credentials file"
}

variable "mig_name" {
  description = "The desired name of the Managed Instance Group to deploy"
}

variable "image" {
  description = "The Docker image to deploy to GCE instances"
}

variable "image_port" {
  description = "The port the image exposes for HTTP requests"
}

variable "mig_instance_count" {
  description = "The number of instances to run in the managed instance group"
  default     = "2"
}

variable "enable_http_health_check" {
  description = "Whether to enable HTTP health checks"
  default     = true
}

variable "machine_type" {
  description = "The GCP machine type to deploy"
}

variable "region" {
  description = "The GCP region to deploy instances into"
}

variable "zone" {
  description = "The GCP zone to deploy instances into"
}

variable "gce_ssh_user" {
  description = "The username to provision with an auto-generated SSH keypair."
  default     = "user"
}

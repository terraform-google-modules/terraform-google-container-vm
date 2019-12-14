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
  description = "The project ID to deploy resources into"
}

variable "subnetwork_project" {
  description = "The project ID where the desired subnetwork is provisioned"
}

variable "subnetwork" {
  description = "The name of the subnetwork to deploy instances into"
}

variable "instance_name" {
  description = "The desired name to assign to the deployed instance"
  default     = "hello-world-container-vm"
}

variable "region" {
  description = "The GCP region to deploy instances into"
  type        = string
  default     = "us-east4"
}

variable "zone" {
  description = "The GCP zone to deploy instances into"
  type        = string
  default     = "us-east4-b"
}

variable "client_email" {
  description = "Service account email address"
  type        = string
  default     = ""
}

variable "cos_image_name" {
  description = "The forced COS image to use instead of latest"
  default     = "cos-stable-77-12371-89-0"
}

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
  type        = string
}

variable "subnetwork" {
  description = "The name of the subnetwork to deploy instances into"
  type        = string
  default     = "mig-subnet"
}

variable "mig_name" {
  description = "The desired name to assign to the deployed managed instance group"
  type        = string
  default     = "mig-test"
}

variable "mig_instance_count" {
  description = "The number of instances to place in the managed instance group"
  type        = string
  default     = "2"
}

variable "image" {
  description = "The Docker image to deploy to GCE instances"
  type        = string
  default     = "gcr.io/google-samples/hello-app:1.0"
}

variable "image_port" {
  description = "The port the image exposes for HTTP requests"
  type        = number
  default     = 8080
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

variable "network" {
  description = "The GCP network"
  type        = string
  default     = "mig-net"
}

variable "additional_metadata" {
  type        = map
  description = "Additional metadata to attach to the instance"
  default     = {}
}

variable "service_account" {
  type = object({
    email  = string,
    scopes = list(string)
  })
  default = {
    email  = ""
    scopes = ["cloud-platform"]
  }
}

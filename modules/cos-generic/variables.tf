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

variable "project_id" {
  description = "Project id where the instances will be created."
}

variable "region" {
  description = "Region for external addresses."
}

variable "zone" {
  description = "Instance zone."
}

variable "subnetwork" {
  description = "Self link of the VPC subnet to use for the internal interface."
}

variable "instance_count" {
  description = "Number of instances to create."
  default     = 1
}

variable "vm_tags" {
  description = "Additional network tags for the instances."
  default     = []
}

variable "instance_type" {
  description = "Instance machine type."
  default     = "g1-small"
}

variable "scopes" {
  description = "Instance scopes."

  default = [
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring.write",
    "https://www.googleapis.com/auth/pubsub",
    "https://www.googleapis.com/auth/service.management.readonly",
    "https://www.googleapis.com/auth/servicecontrol",
    "https://www.googleapis.com/auth/trace.append",
  ]
}

variable "service_account" {
  description = "Instance service account."
  default     = ""
}

variable "prefix" {
  description = "Prefix to prepend to resource names."
  default     = ""
}

variable "boot_disk_size" {
  description = "Size of the boot disk."
  default     = 10
}

variable "stackdriver_logging" {
  description = "Enable the Stackdriver logging agent."
  default     = true
}

variable "stackdriver_monitoring" {
  description = "Enable the Stackdriver monitoring agent."
  default     = true
}

variable "labels" {
  type        = "map"
  description = "Labels to be attached to the resources"

  default = {
    service = "coredns"
  }
}

variable "reserve_ip" {
  description = "Reserve an IP address for the instance instead of using an ephemeral address."
  default     = false
}

variable "cloud_init" {
  description = "Path to a file that will be used for the cloud-config template."
  default     = ""
}

variable "cloud_init_custom_var" {
  description = "String passed in to the cloud-config template as custome variable."
  default     = ""
}

variable "allow_stopping_for_update" {
  description = "Allow stopping the instance for specific Terraform changes."
  default     = false
}

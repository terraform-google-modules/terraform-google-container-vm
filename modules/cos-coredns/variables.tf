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
  type        = string
}

variable "region" {
  description = "Region for external addresses."
  type        = string
}

variable "zone" {
  description = "Instance zone."
  type        = string
}

variable "network" {
  description = "Self link of the VPC subnet to use for firewall rules."
  type        = string
}

variable "subnetwork" {
  description = "Self link of the VPC subnet to use for the internal interface."
  type        = string
}

variable "instance_count" {
  description = "Number of instances to create."
  type        = number
  default     = 1
}

variable "network_tag" {
  description = "Network tag that identifies the instances."
  type        = string
  default     = "coredns"
}

variable "vm_tags" {
  description = "Additional network tags for the instances."
  type        = list(string)
  default     = []
}

variable "instance_type" {
  description = "Instance machine type."
  type        = string
  default     = "g1-small"
}

variable "scopes" {
  description = "Instance scopes."
  type        = list(string)
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
  type        = string
  default     = ""
}

variable "prefix" {
  description = "Prefix to prepend to resource names."
  type        = string
  default     = ""
}

variable "create_firewall_rule" {
  description = "Create tag-based firewall rule."
  type        = bool
  default     = false
}

variable "client_cidrs" {
  description = "Client IP CIDR ranges to set in the firewall rule."
  type        = list(string)
  default     = []
}

variable "boot_disk_size" {
  description = "Size of the boot disk."
  type        = number
  default     = 10
}

variable "container_image" {
  description = "CoreDNS container version."
  type        = string
  default     = "coredns/coredns"
}

variable "corefile" {
  description = "Path to the CoreDNS configuration file to use."
  type        = string
  default     = ""
}

variable "log_driver" {
  description = "Docker log driver to use for CoreDNS."
  type        = string
  default     = "gcplogs"
}

variable "stackdriver_logging" {
  description = "Enable the Stackdriver logging agent."
  type        = bool
  default     = true
}

variable "stackdriver_monitoring" {
  description = "Enable the Stackdriver monitoring agent."
  type        = bool
  default     = true
}

variable "labels" {
  description = "Labels to be attached to the resources"
  type        = map(string)
  default = {
    service = "coredns"
  }
}

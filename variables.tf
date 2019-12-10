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

variable "container" {
  // This is necessary to work around a limitation in Terraform 0.12. If this is set to `map`, as intended, Terraform expects all values within the map to have the same type, which is not the case here.
  type        = any
  description = "A description of the container to deploy"
  default = {
    image   = "gcr.io/google-containers/busybox"
    command = "ls"
  }
}

variable "volumes" {
  // This is necessary to work around a limitation in Terraform 0.12. If this is set to `map`, as intended, Terraform expects all values within the map to have the same type, which is not the case here.
  type        = any
  description = "A set of Docker Volumes to configure"
  default     = []
}

variable "restart_policy" {
  description = "The restart policy for a Docker container. Defaults to `OnFailure`"
  type        = string
  default     = "OnFailure"
}

variable "cos_image_family" {
  description = "The COS image family to use (eg: stable, beta, or dev)"
  type        = string
  default     = "stable"
}

variable "cos_image_name" {
  description = "Name of a specific COS image to use instead of the latest cos family image"
  type        = string
  default     = null
}

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

locals {
  cos_image_name         = var.cos_image_name
  cos_image_family       = var.cos_image_name == null ? "cos-${var.cos_image_family}" : null
  cos_project            = "cos-cloud"
  invalid_restart_policy = var.restart_policy != "OnFailure" && var.restart_policy != "UnlessStopped" && var.restart_policy != "Always" && var.restart_policy != "No" ? 1 : 0

  spec = {
    spec = {
      containers    = [var.container]
      volumes       = var.volumes
      restartPolicy = var.restart_policy
    }
  }

  spec_as_yaml = yamlencode(local.spec)
}

data "google_compute_image" "coreos" {
  name    = local.cos_image_name
  family  = local.cos_image_family
  project = local.cos_project
}

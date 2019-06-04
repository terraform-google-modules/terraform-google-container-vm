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
  coreos_image_family    = "cos-stable"
  coreos_project         = "cos-cloud"
  invalid_restart_policy = "${var.restart_policy != "OnFailure" && var.restart_policy != "UnlessStopped" && var.restart_policy != "Always" && var.restart_policy != "No" ? 1 : 0}"

  spec = {
    spec = {
      containers    = ["${var.container}"]
      volumes       = "${var.volumes}"
      restartPolicy = "${var.restart_policy}"
    }
  }
}

data "google_compute_image" "coreos" {
  family  = "${local.coreos_image_family}"
  project = "${local.coreos_project}"
}

resource "null_resource" "validate_restart_policy" {
  count = "${local.invalid_restart_policy}"

  provisioner "local-exec" {
    command = "echo ERROR: Invalid restart_policy ${var.restart_policy} was provided. Must be one of OnFailure, UnlessStopped, Always, or No"
  }

  provisioner "local-exec" {
    command = "false"
  }
}

data "external" "spec_as_yaml" {
  program = ["ruby", "${path.module}/helpers/map_to_yaml.rb"]

  query = {
    root = "${jsonencode(local.spec)}"
  }
}

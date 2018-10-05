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

variable "containers" {
	type = "list"
	description = "..."
	default = [
		{
			image = "gcr.io/google-containers/busybox"
			command = "ls"
		}
	]
}

variable "volumes" {
	type = "list"
	// TODO note in README that disks will NOT be provisioned, and have to already exist and be mounted
	description = "..."
	default = [
		{
			name = "tempfs-0"
		}
	]
}

variable "restart_policy" {
	description = "The restart policy for a Docker container. Defaults to `OnFailure`"
	default = "OnFailure"
}

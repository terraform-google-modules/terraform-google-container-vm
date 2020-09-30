#!/usr/bin/env bash

# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Generates a config file with templated values.
#
# Terraform interpolation uses standard shell interpolation syntax ($).
# So shell interpolation inside a Terraform template must be escaped ($$).
# Command substitution does not need escaping ($).

set -o errexit -o nounset -o pipefail -o posix

boot_timestamp="$(date --iso-8601=ns)"

mkdir -p "$(dirname "${config_path}")"

cat > "${config_path}" << EOF
{
    "instance_name": "${instance_name}",
    "boot_timestamp": "$${boot_timestamp}",
}
EOF

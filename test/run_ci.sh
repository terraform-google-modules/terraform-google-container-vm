#!/usr/bin/env bash

# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e
set -x

if [ -z "${PROJECT_ID}" ]; then
	echo "The PROJECT_ID ENV variable must be set to proceed. Aborting."
	exit 1
fi

if [ -z "${SERVICE_ACCOUNT_JSON}" ]; then
	echo "The SERVICE_ACCOUNT_JSON ENV variable must be set to proceed. Aborting."
	exit 1
fi

export TF_VAR_project_id="${PROJECT_ID}"
export TF_VAR_region="${REGION:-us-east4}"


DELETE_AT_EXIT="$(mktemp -d)"
finish() {
	[[ -d "${DELETE_AT_EXIT}" ]] && rm -rf "${DELETE_AT_EXIT}"
}
trap finish EXIT
CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE="$(TMPDIR="${DELETE_AT_EXIT}" mktemp)"
set +x
echo "${SERVICE_ACCOUNT_JSON}" > "${CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE}"
set -x
GOOGLE_APPLICATION_CREDENTIALS="${CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE}"
declare -rx CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE GOOGLE_APPLICATION_CREDENTIALS
set +e
make test_integration
result=$?
set -e
if [ "$result" -ne "0" ]; then
	bundle exec kitchen destroy
	exit $result
fi

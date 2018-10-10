# Copyright 2018 Google LLC
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

from terraform_external_data import terraform_external_data
from libcloud.compute.types import Provider
from libcloud.compute.providers import get_driver
import json


@terraform_external_data
def get_ipv4_from_gce_instance(query):
    """
    Get an IPv4 address from a GCE instance's `self_link` attribute.
    """

    credentials_file = query['credentials_file']
    credentials_file_data = json.loads(open(credentials_file, "r").read())

    ComputeEngine = get_driver(Provider.GCE)
    driver = ComputeEngine(
        credentials_file_data['client_email'],
        credentials_file,
        project=query['project_id']
    )

    instance_link = query['instance_link']
    instance_link_parts = instance_link.split("/")
    instance_zone = instance_link_parts[9]
    instance_name = instance_link_parts[len(instance_link_parts)-1]

    node = driver.ex_get_node(instance_name, instance_zone)
    return {
        'ipv4': node.public_ips[0]
    }


if __name__ == '__main__':
    get_ipv4_from_gce_instance()

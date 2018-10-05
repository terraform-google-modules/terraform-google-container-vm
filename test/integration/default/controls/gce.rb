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

project_id = attribute('project_id', required: true, type: :string)
zone = attribute('zone', required: true, type: :string)
instance_name = attribute('instance_name', required: true, type: :string)
network = attribute('network', type: :string, default: "default")
subnetwork = attribute('subnetwork', type: :string, default: "default")
image = attribute('image', required: true, type: :string)
machine_type = attribute('machine_type', type: :string, default: "n1-standard-1")

control "gce" do
  title "Google Compute Engine instance configuration"

  describe command("gcloud --project=#{project_id} compute instances describe #{instance_name} --zone=#{zone} --format json") do
    its('exit_status') { should be 0 }
    its('stderr') { should eq '' }

    # let!(:metadata) do
    #   raise subject.stdout.inspect
    #   if subject.exit_status == 0
    #     JSON.parse(subject.stdout)
    #   else
    #     {}
    #   end
    # end

    # it "is in a running state" do
    #   expect(metadata['status']).to eq 'RUNNING'
    # end

    # it "is in the correct network" do
    #   expect(metadata['networkInterfaces'][0]['network']).to eq network
    # end

    # it "is in the correct subnetwork" do
    #   expect(metadata['networkInterfaces'][0]['subnetwork']).to eq subnetwork
    # end

    # it "is the expected machine type" do
    #   expect(metadata['machineType']).to eq machine_type
    # end

    # it "has the expected labels" do
    #   expect(metadata['labels'].keys).to include "container-vm"
    # end

    # it "is configured with the expected image" do
    #   expect(metadata['metadata']['items'][0]['value']['spec']['containers'][0]).to eq({
    #     image: image,
    #     name: instance_name,
    #     securityContext: {
    #       privileged: false,
    #     },
    #     stdin: false,
    #     tty: false,
    #     volumeMounts: [],
    #   })
    # end
  end
end

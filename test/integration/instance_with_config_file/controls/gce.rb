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

project_id = attribute('project_id')
zone = attribute('zone')
instance_name = attribute('instance_name')
network = attribute('network')
subnetwork = attribute('subnetwork')
vm_container_label = attribute('vm_container_label')

control "gce" do
  title "Google Compute Engine instance configuration"

  describe command("gcloud --project=#{project_id} compute instances describe #{instance_name} --zone=#{zone} --format json") do
    its('exit_status') { should be 0 }
    its('stderr') { should eq '' }

    let!(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    let(:container_declaration) do
      YAML.load(data['metadata']['items'].select { |h| h['key'] == 'gce-container-declaration' }.first['value'].gsub("\t", "  "))
    end

    it "is in a running state" do
      expect(data['status']).to eq 'RUNNING'
    end

    it "is in the correct network" do
      expect(data['networkInterfaces'][0]['network']).to end_with network
    end

    it "is in the correct subnetwork" do
      expect(data['networkInterfaces'][0]['subnetwork']).to end_with subnetwork
    end

    it "has the expected labels" do
      expect(data['labels']['container-vm']).to eq vm_container_label
    end

    it "is configured with the expected container, volumes, and restart policy" do
      expect(container_declaration).to eq({
        "spec" => {
          "containers" => [
            {
              "image" => "gcr.io/google-samples/hello-app:1.0",
              "volumeMounts" => [
                {
                  "mountPath" => "/config.json",
                  "name" => "config",
                  "readOnly" => true,
                },
              ],
            },
          ],
          "restartPolicy" => "Always",
          "volumes" => [
            {
              "name" => "config",
              "hostPath" => {
                "path" => "/etc/hello-app/config.json",
              },
            },
          ],
        },
      })
    end
  end
end

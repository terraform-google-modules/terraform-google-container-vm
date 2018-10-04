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
instance_name = attribute('instance_name', required: true, type: :string)
network = attribute('network', type: :string, default: "default")
subnetwork = attribute('subnetwork', type: :string, default: "default")
image = attribute('image', required: true, type: :string)
machine_type = attribute('machine_type', type: :string, default: "n1-standard-1")
zone = attribute('zone', required: true, type: :string)

control "terraform" do
  title "Module Outputs"

  {

  }.each do |output_name, expected_value|
    describe command("terraform output #{output_name}") do
      its('exit_status') { should be 0 }
      its('stderr') { should eq '' }

      let(:value) { subject.stdout }

      it "should match the expected value" do
        expect(value).to eq expected_value
      end
    end
  end
end

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

image = attribute('image', required: true, type: :string)
restart_policy = attribute('restart_policy', required: true, type: :string)

control "docker" do
  title "Docker containers"

  describe docker.containers do
    its('images') { should include image }

    let!(:running_containers) { docker.containers.ids.map { |id| docker.object(id) } }
    let(:container) { running_containers.first { |d| d.Config.Image == image } }
    
    it "should have our container" do
      expect(container).not_to be_nil
    end

    it "should be running the designated image" do
      expect(container.State.Status).to eq "running"
    end

    it "should have a properly configured restart policy" do
      expect(container.HostConfig.RestartPolicy.Name).to eq restart_policy.downcase
    end

    # TODO test volumes
  end
end

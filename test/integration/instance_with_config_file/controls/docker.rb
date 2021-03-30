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

container_definition = attribute('container')
volume_definitions = attribute('volumes')

control "docker" do
  title "Docker containers"

  describe docker.containers do
    its('images') { should include "gcr.io/google-samples/hello-app:1.0" }

    let!(:running_containers) { docker.containers.ids.map { |id| docker.object(id) } }
    let(:container) { running_containers.detect { |d| d.Config.Image == "gcr.io/google-samples/hello-app:1.0" } }

    it "should have our container" do
      expect(container).not_to be_nil
    end

    it "should be running the designated image" do
      expect(container.State.Status).to eq "running"
    end

    it "should have a properly configured restart policy" do
      expect(container.HostConfig.RestartPolicy.Name).to eq "always"
    end

    let(:mounts) { container.Mounts ? container.Mounts : [] }
    let(:mount_definitions) { container_definition[:volumeMounts] ? container_definition[:volumeMounts] : [] }
    let(:host_path_volume_definitions) { volume_definitions.select { |v| v.keys.include?(:hostPath) } }

    it "should have the right number of disk mounts" do
      expect(mounts.count).to eq mount_definitions.count
    end

    it "should have the right number of bind mounts" do
      expect(mounts.select { |m| m.Type == "bind" }.count).to eq host_path_volume_definitions.count
    end

    it "should have the right number of hostPath volumes on the right mount points" do
      mounts.each do |mount|
        # mount destinations have to be unique, so use it to lookup the mount definition
        mount_def = mount_definitions.find { |md| md[:mountPath] == mount.Destination }
        expect(mount_def).not_to be_nil
        # use the mount definition name to lookup the volume definition by name
        volume_def = host_path_volume_definitions.find { |vd| vd[:name] == mount_def[:name] }
        expect(volume_def).not_to be_nil

        expect(mount).to eq({
          "Destination" => mount_def[:mountPath],
          "Mode" => mount_def[:readOnly] ? "ro" : "rw",
          "Propagation" => "rprivate",
          "RW" => !mount_def[:readOnly],
          "Source" => volume_def[:hostPath][:path],
          "Type" => "bind",
        })
      end
    end
  end
end

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

http_address = attribute('http_address')
port = attribute('http_port')

control "www" do
  title "WWW Access"

  describe "HTTP service" do
    let(:resource) do
      http_resource = -> { http("http://#{http_address}:#{port}/", method: 'GET', open_timeout: 30, read_timeout: 30) }
      Timeout::timeout(400) do
        r = http_resource.call
        until r.status == 200
          sleep 0.5
          r = http_resource.call
        end
        r
      end
    end

    it "returns 200" do
      expect(resource.status).to eq 200
    end

    it "has the correct HTTP body" do
      expect(resource.body).to include 'Hello, world!'
    end
  end
end

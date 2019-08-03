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

# Test disabled due to flappiness - because this makes live network requests, it is prone to sporadic failure.

# timeout_short_circuit = false
#
# control "www" do
  # title "WWW Access"
#
  # describe "HTTP service" do
    # let(:resource) do
      # raise Timeout::Error if timeout_short_circuit
      # begin
        # Timeout::timeout(600) do
          # r = http("http://#{http_address}:#{port}/", method: "GET", open_timeout: 10, read_timeout: 10)
          # until r.status == 200
            # if r.status == 403
              # return r
            # end
            # sleep 1
            # r = http("http://#{http_address}:#{port}/", method: "GET", open_timeout: 10, read_timeout: 10)
          # end
          # r
        # end
      # rescue Timeout::Error
        # timeout_short_circuit = true
        # raise
      # end
    # end
#
    # it "returns 200" do
      # expect(resource.status).to eq 200
    # end
#
    # it "has the correct HTTP body" do
      # expect(resource.body).to include 'Hello, world!'
    # end
  # end
# end

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

http_address = attribute('http_address', required: true, type: :string)
port = attribute('http_port', required: true, type: :string)

control "www" do
  title "WWW Access"

  describe http("http://#{http_address}:#{port}/", method: 'GET', open_timeout: 30, read_timeout: 30) do
    its('status') { should eq 200 }
    its('body') { should include 'Hello, world!' }
  end
end

#
# Cookbook Name:: strongdm
# Spec:: gateway
#
# Copyright © 2018 Applause App Quality, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

describe file('/usr/local/bin/sdm') do
  it { should exist }
  it { should be_readable }
  it { should be_executable }
  it { should be_symlink }
  its('link_path') { should eq '/opt/strongdm/bin/sdm' }
end

describe file('/etc/sysconfig/sdm-proxy') do
  it { should exist }
  it { should be_readable }
  its('owner') { should eq 'strongdm' }
  its('content') { should include 'SDM_RELAY_TOKEN=' }
end

describe service('sdm-proxy') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

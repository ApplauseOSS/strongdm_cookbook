#
# Cookbook Name:: strongdm
# Recipe:: gateway
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

include_recipe 'strongdm::default'

relay_token = ''

ruby_block 'get-relay-token' do
  block do
    relay_token = sdm_relay_token
  end
end

execute 'sdm-install-gateway' do
  command "#{Chef::Config['file_cache_path']}/sdm install --relay"
  environment(
    lazy do
      {
        'SUDO_GID' => Mixlib::ShellOut.new("getent passwd #{node['strongdm']['user']}").run_command.stdout.split(':')[3],
        'SUDO_UID' => Mixlib::ShellOut.new("getent passwd #{node['strongdm']['user']}").run_command.stdout.split(':')[2],
        'SUDO_USER' => node['strongdm']['user'],
        'HOME' => '/root',
        'LOGNAME' => 'root',
        'UID' => '0',
        'USER' => 'root',
        'USERNAME' => 'root',
        'SDM_RELAY_TOKEN' => relay_token,
      }
    end
  )
  creates '/opt/strongdm/bin/sdm'
end
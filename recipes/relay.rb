#
# Cookbook Name:: strongdm
# Recipe:: relay
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

Chef::Resource::RubyBlock.send(:include, StrongDM::Helpers)
Chef::Resource::Execute.send(:include, StrongDM::Helpers)

relay_token = ''
ruby_block 'get-relay-token' do
  block do
    relay_token = sdm_relay_token('relay')
  end
end

execute 'sdm-install-relay' do
  command "#{sdm} install --relay"
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
  creates '/etc/systemd/system/sdm-proxy.service'
  notifies :delete, 'directory[/root/.sdm]', :immediately
end

directory '/root/.sdm' do
  action :nothing
  recursive true
end

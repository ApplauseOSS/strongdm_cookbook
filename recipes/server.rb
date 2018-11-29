#
# Cookbook Name:: strongdm
# Recipe:: server
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

Chef::Resource::Execute.send(:include, StrongDM::Helpers)

execute 'sdm-login-with-admin-token' do
  command "#{sdm} login"
  environment('SDM_ADMIN_TOKEN' => node['strongdm']['admin_token'])
end

directory '/opt/strongdm/.ssh' do
  recursive true
  owner node['strongdm']['user']
  group node['strongdm']['user']
  mode 0700
end

execute 'sdm-admin-add-servers' do
  command "#{sdm} admin servers add -p #{node['fqdn']} #{node['strongdm']['user']}@#{node['ipaddress']} >> /opt/strongdm/.ssh/authorized_keys"
  environment('SDM_ADMIN_TOKEN' => node['strongdm']['admin_token'])
  not_if "#{sdm} admin servers list | grep #{node['fqdn']}"
  creates '/opt/strongdm/.ssh/authorized_keys'
end

file '/opt/strongdm/.ssh/authorized_keys' do
  owner node['strongdm']['user']
  group node['strongdm']['user']
end

node['strongdm']['default_grant_roles'].each do |role|
  execute "sdm-admin-roles-grant-#{role}" do
    command "#{sdm} admin roles grant #{node['fqdn']} #{role}"
    environment('SDM_ADMIN_TOKEN' => node['strongdm']['admin_token'])
  end
end

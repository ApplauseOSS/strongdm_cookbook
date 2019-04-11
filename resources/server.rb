#
# Cookbook Name:: strongdm
# Resource:: server
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

property :admin_token, [NilClass, String]
property :advertise_address, [NilClass, String]
property :granted_roles, [NilClass, Array, String]
property :home_dir, [NilClass, String]
property :instance_name, String, name_property: true
property :user_name, [String, Integer], default: 'strongdm'

action :create do
  admin_token = new_resource.admin_token || node['strongdm']['admin_token']
  ip = new_resource.advertise_address || node.run_state['ipaddress']
  ### TODO: make this pick the correct location
  home_dir = new_resource.home_dir || "/home/#{new_resource.user_name}"
  roles = new_resource.granted_roles || [*node['strongdm']['default_grant_roles']]

  user new_resource.user_name do
    home home_dir
    manage_home true
  end

  directory '/opt/strongdm/.sdm' do
    recursive true
    owner new_resource.user_name
    group new_resource.user_name
    mode 0700
  end

  directory "#{home_dir}/.ssh" do
    recursive true
    owner new_resource.user_name
    group new_resource.user_name
    mode 0700
  end

  directory "#{home_dir}/.sdm" do
    owner new_resource.user_name
    group new_resource.user_name
    mode 0700
  end

  pubkey = 'DO-NOT-MATCH'
  ruby_block 'register-server' do
    block do
      server = Mixlib::ShellOut.new(
        sdm, 'admin', 'servers', 'add', '-p',
        new_resource.instance_name,
        "#{new_resource.user_name}@#{ip}",
        'environment' => { 'SDM_ADMIN_TOKEN' => admin_token }
      )
      server.run_command
      pubkey = server.stdout.chomp
      raise 'Unable to fetch public key from strongDM' if pubkey.empty?
      keyfile = ::File.new("#{home_dir}/.ssh/authorized_keys", 'a')
      keyfile.write(pubkey)
      keyfile.close
    end
    notifies :delete, "file[#{home_dir}/.sdm/roles]", :immediately
    not_if do
      # short-circuits to prevent reaching out to strongdm
      return false unless ::File.exist?("#{home_dir}/.ssh/authorized_keys")
      return false if ::File.empty?("#{home_dir}/.ssh/authorized_keys")
      cmd = Mixlib::ShellOut.new(
        sdm, 'admin', 'servers', 'list',
        'environment' => { 'SDM_ADMIN_TOKEN' => admin_token }
      )
      # do sdm admin servers list
      cmd.run_command
      if cmd.exitstatus == 0 && cmd.stdout.chomp.include?(node['fqdn'])
        true
      else
        false
      end
    end
  end

  file "#{home_dir}/.ssh/authorized_keys" do
    owner new_resource.user_name
    group new_resource.user_name
  end

  file "#{home_dir}/.sdm/roles" do
    content roles.sort.join("\n")
    owner new_resource.user_name
    group new_resource.user_name
  end

  roles.sort.each do |role|
    execute "grant-strongdm-role-#{role}" do
      command "#{sdm} admin roles grant #{new_resource.instance_name} #{role}"
      environment('SDM_ADMIN_TOKEN' => admin_token)
      action :nothing
      subscribes :run, "file[#{home_dir}/.sdm/roles]", :delayed
      subscribes :run, 'ruby_block[register-server]', :delayed
    end
  end
end

action_class do
  include StrongDM::Helpers
end

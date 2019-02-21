#
# Cookbook Name:: strongdm
# Resource:: install
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

property :admin_token, [NilClass, String], default: nil
property :advertise_address, [NilClass, String], default: nil
property :bind_address, String, default: '0.0.0.0'
property :bind_port, [String, Integer], default: 5000
property :home_dir, [NilClass, String]
property :instance_name, String, name_property: true
property :port, [String, Integer], default: 5000
property :relay_token, [NilClass, String], default: nil
property :type, [String, Array], default: 'relay'
property :user_name, [String, Integer], default: 'strongdm'

action :create do
  admin_token = new_resource.admin_token ? new_resource.admin_token : node['strongdm']['admin_token']
  ip = new_resource.advertise_address ? new_resource.advertise_address : node.run_state['ipaddress']
  ### TODO: make this pick the correct location
  home_dir = new_resource.home_dir ? new_resource.home_dir : "/home/#{new_resource.user_name}"
  relay_token = if new_resource.relay_token
                  new_resource.relay_token
                else
                  sdm_relay_token(
                    admin_token,
                    new_resource.instance_name,
                    new_resource.type,
                    ip,
                    new_resource.port,
                    new_resource.bind_address,
                    new_resource.bind_port
                  )
                end

  # Sanity check our code
  Chef::Application.fatal!('Unable to fetch SDM_RELAY_TOKEN') if relay_token.nil?

  user new_resource.user_name do
    home home_dir
    manage_home true
  end

  execute "sdm install #{new_resource.type}" do
    command "#{sdm} install --relay"
    environment(
      lazy do
        {
          'SUDO_GID' => sdm_gid(new_resource.user_name),
          'SUDO_UID' => sdm_uid(new_resource.user_name),
          'SUDO_USER' => new_resource.user_name,
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
end

action_class do
  include StrongDM::Helpers
end

#
# Cookbook Name:: strongdm
# Library:: helpers
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

module StrongDM
  module Helpers
    def sdm_relay_token(type = 'relay')
      token = Mixlib::ShellOut.new(
        sdm,
        'relay',
        type == 'gateway' ? 'create-gateway' : 'create',
        '--name',
        node['fqdn'],
        "#{node['ipaddress']}:#{node['strongdm']["#{type}_port"]}",
        "#{node['strongdm']["#{type}_bind_address"]}:#{node['strongdm']["#{type}_bind_port"]}",
        'env' => {
          'SDM_ADMIN_TOKEN' => node['strongdm']['admin_token'],
        }
      )
      token.run_command
      # Remove temporary admin credentials
      Mixlib::ShellOut.new('rm -f /root/.sdm/*').run_command
      token.stdout.chomp
    end

    def sdm_grant_role(role, host = node['fqdn'])
      grant = Mixlib::ShellOut.new(
        sdm,
        'admin', 'roles', 'grant',
        host,
        role,
        'env' => {
          'SDM_ADMIN_TOKEN' => node['strongdm']['admin_token'],
        }
      )
      grant.run_command
    end

    def sdm
      return "#{Chef::Config['file_cache_path']}/sdm" if lazy { ::File.exist?("#{Chef::Config['file_cache_path']}/sdm") }
      # assume we're in the PATH
      'sdm'
    end
  end
end

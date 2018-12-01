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
    def sdm_relay_token(admin_token, name, type = 'relay', ip = nil, port = 5000, bind_ip = '0.0.0.0', bind_port = 5000)
      return nil if admin_token.nil?
      ip = node['ipaddress'] if ip.nil?
      name = node['fqdn'] if name.nil?
      token = Mixlib::ShellOut.new(
        sdm,
        'relay',
        type == 'gateway' ? 'create-gateway' : 'create',
        '--name',
        name,
        "#{ip}:#{port}",
        "#{bind_ip}:#{bind_port}",
        'environment' => { 'SDM_ADMIN_TOKEN' => admin_token }
      )
      token.run_command
      # Remove temporary admin credentials
      Mixlib::ShellOut.new('rm -f /root/.sdm/*').run_command
      token.stdout.chomp
    end

    def sdm_gid(user)
      Mixlib::ShellOut.new("getent passwd #{user}").run_command.stdout.split(':')[3].chomp
    end

    def sdm_uid(user)
      Mixlib::ShellOut.new("getent passwd #{user}").run_command.stdout.split(':')[2].chomp
    end

    # Finds the "sdm" binary
    def sdm
      return "#{Chef::Config['file_cache_path']}/sdm" if lazy { ::File.exist?("#{Chef::Config['file_cache_path']}/sdm") }
      # assume we're in the PATH
      'sdm'
    end
  end
end

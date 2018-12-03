#
# Cookbook Name:: strongdm
# Spec:: server
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

require 'spec_helper'

describe 'strongdm::server' do
  context 'with all attributes default' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '7.4.1708') do
        stub_command(/sdm admin servers list/).and_return(false)
      end.converge(described_recipe)
    end

    it 'runs execute[sdm-login-with-admin-token]' do
      expect(chef_run).to run_execute('sdm-login-with-admin-token')
    end

    it 'runs execute[sdm-admin-add-servers]' do
      expect(chef_run).to run_execute('sdm-admin-add-servers')
    end

    it 'creates /opt/strongdm/.sdm' do
      expect(chef_run).to create_directory('/opt/strongdm/.sdm')
    end

    it 'creates /opt/strongdm/.ssh' do
      expect(chef_run).to create_directory('/opt/strongdm/.ssh')
    end

    it 'creates /opt/strongdm/.ssh/authorized_keys' do
      expect(chef_run).to create_file('/opt/strongdm/.ssh/authorized_keys')
    end

    it 'creates /opt/strongdm/.sdm/roles' do
      expect(chef_run).to create_file('/opt/strongdm/.sdm/roles')
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end

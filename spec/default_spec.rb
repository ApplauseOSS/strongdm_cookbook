#
# Cookbook Name:: strongdm
# Spec:: default
#
# Copyright © 2018-2019 Applause App Quality, Inc.
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

describe 'strongdm::default' do
  context 'with all attributes default' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '7.4.1708') do |node|
      end.converge(described_recipe)
    end

    it 'installs unzip' do
      expect(chef_run).to install_package('unzip')
    end

    it 'downloads sdm.zip' do
      expect(chef_run).to create_remote_file("#{Chef::Config['file_cache_path']}/sdm.zip")
    end

    it 'extracts sdm.zip' do
      expect(chef_run).to run_execute('unzip-sdm.zip')
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end

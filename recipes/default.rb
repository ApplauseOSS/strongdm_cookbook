#
# Cookbook Name:: strongdm
# Recipe:: default
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

package 'unzip'

remote_file "#{Chef::Config['file_cache_path']}/sdm.zip" do
  source node['strongdm']['url']
end

execute 'unzip-sdm.zip' do
  command 'unzip sdm.zip'
  cwd Chef::Config['file_cache_path']
  creates "#{Chef::Config['file_cache_path']}/sdm"
end

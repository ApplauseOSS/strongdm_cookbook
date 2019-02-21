#
# Cookbook Name:: strongdm
# Recipe:: relay
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

include_recipe 'strongdm::default'

strongdm_install node['hostname'] do
  advertise_address node['strongdm']['relay_advertise_address']
  bind_address node['strongdm']['relay_bind_address']
  bind_port node['strongdm']['relay_bind_port']
  port node['strongdm']['relay_port']
  user_name node['strongdm']['user']
  type 'relay'
  action :create
end

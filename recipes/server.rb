#
# Cookbook Name:: strongdm
# Recipe:: server
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

strongdm_server node['fqdn'] do
  admin_token node['strongdm']['admin_token']
  advertise_address node['ipaddress']
  granted_roles node['strongdm']['default_grant_roles']
  ignore_failure node['strongdm']['ignore_registration_failures']
end

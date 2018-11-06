#
# Cookbook Name:: strongDM
# Attributes:: default
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

default['strongdm']['version'] = '0.7.48'
default['strongdm']['checksum'] = '729dd87c1ec4f48be4d37816cf5789c397e3b11de8bf878ab5acdc6b30485145'

default['strongdm']['install_dir'] = '/opt/strongdm'
default['strongdm']['user'] = 'strongdm'

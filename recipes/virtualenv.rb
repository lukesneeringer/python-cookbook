#
# Author:: Seth Chisamore <schisamo@opscode.com>
# Cookbook Name:: python
# Recipe:: virtualenv
#
# Copyright 2011, Opscode, Inc.
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

include_recipe 'python::pip'

python_pip 'virtualenv' do
  action :install
  version node['python']['virtualenv']['version']
end


# Create the virtualenv home.
directory node['python']['virtualenv']['path'] do
  action :create
  group node['python']['virtualenv']['permissions']['group']
  mode node['python']['virtualenv']['permissions']['mode']
  owner node['python']['virtualenv']['permissions']['owner']
end


# Create the virtualenv environment variable file.
# This file will need to be explicitly sourced by Chef whenever
#   virtualenvs must be used, since the lack of a login shell means
#   that it won't be done automatically.
# This functionality is handled for bash using the `python_bash` provider,
#   which accepts a `virtualenv` attribute, and for `python_pip`, which also
#   accepts a `virtualenv` attribute.
template "#{node['python']['virtualenv']['wrapper']['profile']}" do
  action :create
  group 'root'
  mode 0755
  owner 'root'
  source 'virtualenv.sh'
end

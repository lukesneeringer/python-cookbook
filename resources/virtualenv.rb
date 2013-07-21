#
# Author:: Seth Chisamore <schisamo@opscode.com>
# Cookbook Name:: python
# Resource:: virtualenv
#
# Copyright:: 2011, Opscode, Inc <legal@opscode.com>
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

actions :create, :delete
default_action :create if defined?(default_action) # Chef > 10.8

# Default action for Chef <= 10.8
def initialize(*args)
  super
  @action = :create
end


attribute :group, :default => nil, :regex => Chef::Config[:group_valid_regex]
attribute :interpreter, :default => node['python']['virtualenv']['options']['python']
attribute :name, :kind_of => String, :name_attribute => true
attribute :owner, :default => nil, :regex => Chef::Config[:user_valid_regex]
attribute :options, :kind_of => String
attribute :path, :default => node['python']['virtualenv']['path'], :kind_of => String
attribute :prefix, :default => node['python']['virtualenv']['options']['prefix'], :kind_of => String
attribute :prompt, :default => node['python']['virtualenv']['options']['prompt']

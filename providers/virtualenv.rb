#
# Author:: Seth Chisamore <schisamo@opscode.com>
# Cookbook Name:: python
# Provider:: virtualenv
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

require 'chef/mixin/shell_out'
require 'chef/mixin/language'
include Chef::Mixin::ShellOut


def whyrun_supported?
  return true
end


action :create do
  normalize(new_resource)

  unless exists?
    # Build the command.
    venv_command = "#{virtualenv_cmd} #{new_resource.path}/#{new_resource.name}"
    if new_resource.interpreter
      venv_command += " --python=#{new_resource.interpreter}"
    end
    if new_resource.prompt
      venv_command += " --prompt=\"#{new_resource.prompt.sub('$1', new_resource.name)}\""
    end
    if new_resource.options
      venv_command += " #{new_resource.options}"
    end

    # Execute the command, actually creating the virtualenv.
    execute "Creating virtualenv #{new_resource}" do
      command venv_command
      group new_resource.group || node['python']['virtualenv']['permissions']['group']
      user new_resource.owner || node['python']['virtualenv']['permissions']['owner']
    end
    new_resource.updated_by_last_action(true)
  end
end

action :delete do
  normalize(new_resource)

  # We still need to delete with a direct `rm -rf`, becuase `rmvirtualenv`
  # doesn't handle receipt in the same way that `mkvirtualenv` does.
  if exists?
    description = "delete virtualenv #{new_resource} at #{new_resource.path}"
    converge_by(description) do
       Chef::Log.info("Deleting virtualenv #{new_resource} at #{new_resource.path}")
       FileUtils.rm_rf("#{new_resource.path}/#{new_resource.name}")
    end
  end
end


def load_current_resource
  @current_resource = Chef::Resource::PythonVirtualenv.new(new_resource.name)
  @current_resource.path(new_resource.path)

  if exists?
    cstats = ::File.stat(current_resource.path)
    @current_resource.owner(cstats.uid)
    @current_resource.group(cstats.gid)
  end
  @current_resource
end


private
def normalize(nr)
  # The way that virtualenvs are specified has evolved;
  # ensure that they are normalized to the new attributes format.
  if nr.name.include?('/')
    nr.path = nr.name.split('/')[0...-1].join('/')
    nr.name = nr.name.split('/')[-1]
  end
  return nr
end


def virtualenv_cmd
  if node['python']['install_method'].eql?('source')
    ::File.join(node['python']['prefix_dir'], '/bin/virtualenv')
  else
    'virtualenv'
  end
end


def exists?
  path = "#{new_resource.path}/#{new_resource.name}"
  return ::File.exists?(path) && \
         ::File.directory?(path) && \
         ::File.exists?("#{path}/bin/activate")
end

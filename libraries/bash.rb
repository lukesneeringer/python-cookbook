require 'chef/resource/bash'
require 'chef/provider/script'


class Chef
  class Resource
    class Bash #< ::Chef::Resource::Bash
      def initialize(name, run_context=nil)
        super
        @resource_name = :bash
        @interpreter = 'bash'
        @provider = Chef::Provider::Bash
        @virtualenv = nil
      end

      def virtualenv(arg=nil)
        set_or_return(
          :virtualenv,
          arg,
          :kind_of => String
        )
      end
    end
  end
end


class Chef
  class Provider
    class Bash < ::Chef::Provider::Script
      def initialize(new_resource, run_context)
        # If there's a virtualenv specified, ensure that the code
        # is run within that virtualenv.
        if new_resource.virtualenv
          # Determine the virtualenv, with the full path.
          # Note about the syntax here: The `node` variable isn't available
          #   until the superclass constructor runs. However, I need to do this
          #   before that time because I want to ensure that my modification
          #   to the `code` attribute sticks.
          virtualenv = new_resource.virtualenv
          unless virtualenv.include?('/')
            virtualenv = "#{run_context.node['python']['virtualenv']['path']}/#{virtualenv}"
          end

          # Update the code block to ensure that our virtualenv
          # is properly sourced before the block runs.
          full_code = <<-EOF
source #{virtualenv}/bin/activate
#{new_resource.code}
EOF
    
          # Set the code block on the resource.
          new_resource.code(full_code)
        end

        # Now run the superclass constructor.
        super
      end
    end
  end
end

# Install virtualenvwrapper.
python_pip 'virtualenvwrapper' do
  action :install
  version node['python']['virtualenv']['wrapper']['version']
end


# Place the virtualenvwrapper environment variable file.
template "#{node['python']['virtualenv']['wrapper']['profile']}" do
  action :create
  group 'root'
  mode 0755
  owner 'root'
  source 'virtualenvwrapper.sh'
end

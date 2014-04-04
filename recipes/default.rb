execute "apt-get update" do
  command "apt-get update"
end

# Install required packages
%w{ruby1.9.3 curl}.each do |pkg|
  package pkg do
    action :install
  end
end
gem_package "bundler" do
  gem_binary "/usr/bin/gem"
end

# Create shared folders and set permissions
%w{ alm-report alm-report/current alm-report/current/public alm-report/shared alm-report/shared/config alm-report/releases }.each do |dir|
  directory "/var/www/#{dir}" do
    owner node[:alm][:user]
    group node[:alm][:group]
    mode 0755
    recursive true
  end
end

require 'securerandom'
# Create new settings.yml unless it exists already
# Set these passwords in config.json to keep them persistent
unless File.exists?("/var/www/alm-report/shared/config/settings.yml")
  node.set['alm']['key'] = SecureRandom.hex(30) unless node['alm']['key']
  node.set['alm']['secret'] = SecureRandom.hex(30) unless node['alm']['secret']
  node.set['alm']['api_key'] = SecureRandom.hex(30) unless node['alm']['api_key']
else
  settings = YAML::load(IO.read("/var/www/alm-report/shared/config/settings.yml"))
  rest_auth_site_key = settings["#{node[:alm][:environment]}"]["rest_auth_site_key"]
  secret_token = settings["#{node[:alm][:environment]}"]["secret_token"]
  api_key = settings["#{node[:alm][:environment]}"]["api_key"]

  node.set_unless['alm']['key'] = rest_auth_site_key
  node.set_unless['alm']['secret'] = secret_token
  node.set_unless['alm']['api_key'] = api_key
end

template "/var/www/alm-report/shared/config/settings.yml" do
  source 'settings.yml.erb'
  owner node[:alm][:user]
  group node[:alm][:group]
  mode 0644
end

# Create new database.yml unless it exists already
# Set these passwords in config.json to keep them persistent
unless File.exists?("/var/www/alm-report/shared/config/database.yml")
  node.set_unless['mysql']['server_root_password'] = SecureRandom.hex(8)
  node.set_unless['mysql']['server_repl_password'] = SecureRandom.hex(8)
  node.set_unless['mysql']['server_debian_password'] = SecureRandom.hex(8)
  database_exists = false
else
  database = YAML::load(IO.read("/var/www/alm-report/shared/config/database.yml"))
  server_root_password = database["#{node[:alm][:environment]}"]["password"]

  node.set_unless['mysql']['server_root_password'] = server_root_password
  node.set_unless['mysql']['server_repl_password'] = server_root_password
  node.set_unless['mysql']['server_debian_password'] = server_root_password
  database_exists = true
end

template "/var/www/alm-report/shared/config/database.yml" do
  source 'database.yml.erb'
  owner node[:alm][:user]
  group node[:alm][:group]
  mode 0644
end

include_recipe "mysql::server"
include_recipe "database::mysql"

# Create default MySQL database
mysql_database "#{node[:alm][:name]}_#{node[:alm][:environment]}" do
  connection(
    :host     => 'localhost',
    :username => 'root',
    :password => node['mysql']['server_root_password']
  )
  action :create
end

node.set_unless['passenger']['root_path'] = "/var/lib/gems/1.9.1/gems/passenger-#{node['passenger']['version']}"
node.set_unless['passenger']['module_path'] = "/var/lib/gems/1.9.1/gems/passenger-#{node['passenger']['version']}/ext/apache2/mod_passenger.so"
include_recipe "passenger_apache2::mod_rails"

execute "disable-default-site" do
  command "sudo a2dissite default"
end

web_app "alm-report" do
  template "alm-report.conf.erb"
  notifies :restart, resources(:service => "apache2"), :delayed
end
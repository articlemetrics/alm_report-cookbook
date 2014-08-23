# Add PPA for Ruby 2.x
apt_repository 'brightbox-ruby-ng' do
  uri          'http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu'
  distribution 'trusty'
  components   ['main']
  keyserver    'keyserver.ubuntu.com'
  key          'C3173AA6'
end

# Upgrade openssl to latest version
package "openssl" do
  action :upgrade
end

# Install required packages
%w{libxml2-dev libxslt-dev ruby2.1 ruby2.1-dev curl}.each do |pkg|
  package pkg do
    action :install
  end
end

gem_package "bundler" do
  gem_binary "/usr/bin/gem"
end

file '/etc/hostname' do
  content "#{node['alm_report']['hostname']}\n"
  notifies :reload, "ohai[reload]"
end

file '/etc/hosts' do
  content "127.0.0.1  localhost #{node['alm_report']['hostname']}\n::1 ip6-localhost ip6-loopback #{node['alm_report']['hostname']}\nfe00::0 ip6-localnet\nff00::0 ip6-mcastprefix\nff02::1 ip6-allnodes\nff02::2 ip6-allrouters\nff02::3 ip6-allhosts\n"
  notifies :reload, "ohai[reload]"
end

ohai "reload" do
  action :nothing
end

# Create shared folders and set permissions
%w{ alm-report alm-report/current alm-report/shared alm-report/shared/config alm-report/releases }.each do |dir|
  directory "/var/www/#{dir}" do
    owner node['alm_report']['user']
    group node['alm_report']['group']
    mode 0755
    recursive true
  end
end

template "/var/www/alm-report/shared/config/settings.yml" do
  source 'settings.yml.erb'
  owner node['alm_report']['user']
  group node['alm_report']['group']
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
  server_root_password = database[node['alm_report']['environment']]['password']

  node.set_unless['mysql']['server_root_password'] = server_root_password
  node.set_unless['mysql']['server_repl_password'] = server_root_password
  node.set_unless['mysql']['server_debian_password'] = server_root_password
  database_exists = true
end

template "/var/www/alm-report/shared/config/database.yml" do
  source 'database.yml.erb'
  owner node['alm_report']['user']
  group node['alm_report']['group']
  mode 0644
end

include_recipe "mysql::server"
include_recipe "database::mysql"

# Create default MySQL database
mysql_database "alm-report_#{node['alm_report']['environment']}" do
  connection(
    :host     => 'localhost',
    :username => 'root',
    :password => node['mysql']['server_root_password']
  )
  action :create
end

include_recipe "passenger_apache2::mod_rails"

execute "disable-default-site" do
  command "sudo a2dissite default"
end

web_app "alm-report" do
  docroot "/var/www/alm-report/current/public"
  host = node['alm_report']['host']

  # Use the EC2 instance's public IP as hostname
  if node['alm_report']['provider'] == 'aws'
    require 'open-uri'
    host = open('http://169.254.169.254/latest/meta-data/public-ipv4').read
  end

  server_name host
  server_aliases host

  rails_env node['alm_report']['environment']
end

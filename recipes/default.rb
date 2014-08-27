# install and configure dependencies
include_recipe "mysql::server"
include_recipe "passenger_nginx"
include_recipe "memcached"
include_recipe "capistrano"

# create settings file
template "/var/www/#{node['capistrano']['application']}/shared/config/settings.yml" do
  source 'settings.yml.erb'
  owner node['capistrano']['deploy_user']
  group node['capistrano']['group']
  mode 0644
end

# restart passenger
bash "restart passenger" do
  cwd  "/var/www/#{node['capistrano']['application']}/current"
  code "mkdir -p tmp && touch tmp/restart.txt"
end

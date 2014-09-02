# install and configure dependencies
include_recipe "apt"
include_recipe "memcached"
include_recipe "phantomjs"

# install mysql and create configuration file and database
mysql_rails node['alm_report']['name'] do
  deploy_user     node['alm_report']['deploy_user']
  username        node['alm_report']['db']['user']
  password        node['alm_report']['db']['password']
  host            node['alm_report']['db']['host']
  rails_env       node['alm_report']['rails_env']
  action          [:config, :setup]
end

# install nginx and create configuration file and application root
passenger_nginx node['alm_report']['name'] do
  deploy_user     node['alm_report']['deploy_user']
  rails_env       node['alm_report']['rails_env']
  default_server  node['alm_report']['web']['default_server']
end

# create configuration files
capistrano_template "config/settings.yml" do
  source          "settings.yml.erb"
  deploy_user     node['alm_report']['deploy_user']
  application     node['alm_report']['name']
  params          node['alm_report']['settings']
end

# create required files and folders, and deploy application
capistrano node['alm_report']['name'] do
  deploy_user     node['alm_report']['deploy_user']
  rails_env       node['alm_report']['rails_env']
  action          [:config, :bundle_install, :precompile_assets, :migrate, :restart]
end

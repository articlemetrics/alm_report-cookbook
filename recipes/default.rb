# install and configure dependencies
include_recipe "apt"
include_recipe "memcached"

# install mysql and create configuration file and database
mysql_rails "alm-report" do
  action          [:config, :setup]
end

# install nginx and create configuration file and application root
passenger_nginx "alm-report" do
  action          :config
end

# create configuration files
capistrano_template "config/settings.yml" do
  source          "settings.yml.erb"
  application     "alm-report"
  params          node['alm_report']['settings']
end

# create required files and folders, and deploy application
capistrano "alm-report" do
  action          [:config, :bundle_install, :precompile_assets, :migrate, :restart]
end

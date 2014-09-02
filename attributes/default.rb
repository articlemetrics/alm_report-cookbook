require 'securerandom'

default['user'] = 'vagrant'
default['ruby']['packages'] = %w{ libxml2-dev libxslt-dev libmysqlclient-dev nodejs }

default['alm_report']['name'] = "alm-report"
default['alm_report']['deploy_user'] = 'vagrant'
default['alm_report']['group'] = 'vagrant'
default['alm_report']['rails_env'] = "development"
default['alm_report']['web'] = { 'default_server' => true }
default['alm_report']['db'] = {
  'user' => 'vagrant',
  'password' => SecureRandom.hex(10),
  'host' => 'localhost' }

# config/settings.yml
default['alm_report']['settings'] = {
  "api_key"      => SecureRandom.hex(20),
  "key"          => SecureRandom.hex(30),
  "secret"       => SecureRandom.hex(30),
  "ip_range_us"  => nil,
  "ip_range_us"  => nil
}

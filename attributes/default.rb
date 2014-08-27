default['alm_report']['host'] = '10.2.2.2'
default['alm_report']['useragent'] = 'ALM Reports'
default['alm_report']['api_key'] = nil
default['alm_report']['key'] = nil
default['alm_report']['secret'] = nil
default['alm_report']['admin'] = {
  'username' => 'articlemetrics',
  'name' => 'Admin',
  'email' => 'admin@example.com',
  'password' => nil
}
default['alm_report']['ip_range_us'] = nil
default['alm_report']['ip_range_uk'] = nil

default['capistrano']['application'] = "alm-report"
default['capistrano']['rails_env'] = "development"

default['phantomjs']['version'] = "1.9.7"
default['phantomjs']['base_url'] = "https://bitbucket.org/ariya/phantomjs/downloads"

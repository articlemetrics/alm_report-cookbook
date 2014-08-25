default['alm_report']['name'] = 'alm-report'
default['alm_report']['host'] = '10.2.2.2'
default['alm_report']['environment'] = 'development'
default['alm_report']['useragent'] = 'ALM Reports'
default['alm_report']['hostname'] = 'example.com'
default['alm_report']['api_key'] = nil
default['alm_report']['admin'] = {
  'username' => 'articlemetrics',
  'name' => 'Admin',
  'email' => 'admin@example.com',
  'password' => nil
}
default['alm_report']['key'] = nil
default['alm_report']['secret'] = nil
default['alm_report']['user'] = 'vagrant'
default['alm_report']['group'] = 'www-data'
default['alm_report']['ip_range_us'] = nil
default['alm_report']['ip_range_uk'] = nil

default['apache']['version'] = '2.4'
default['apache']['mpm'] = 'event'

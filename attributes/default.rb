require 'securerandom'

default['ruby']['packages'] = %w{ libxml2-dev libxslt-dev libmysqlclient-dev nodejs }

# config/settings.yml
default['alm_report']['settings'] = {
  "api_server"   => "http://alm.plos.org",
  "api_key"      => SecureRandom.hex(20),
  "username"     => "",
  "password"     => "",
  "secret_token" => SecureRandom.hex(34),
  "ip_range_us"  => nil,
  "ip_range_us"  => nil
}

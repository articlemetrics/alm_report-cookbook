require 'securerandom'

default['ruby']['packages'] = %w{ libxml2-dev libxslt-dev libmysqlclient-dev nodejs }

# config/settings.yml
default['alm_report']['settings'] = {
  "api_server"          => "http://alm.plos.org",
  "api_key"             => SecureRandom.hex(20),
  "username"            => nil,
  "password"            => nil,
  "secret_token"        => SecureRandom.hex(34),
  "internal_ip_ranges"  => nil
}

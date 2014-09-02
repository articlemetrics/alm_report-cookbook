require 'securerandom'

default['ruby']['packages'] = %w{ libxml2-dev libxslt-dev libmysqlclient-dev nodejs }

# config/settings.yml
default['alm_report']['settings'] = {
  "api_key"      => SecureRandom.hex(20),
  "secret_token" => SecureRandom.hex(34),
  "ip_range_us"  => nil,
  "ip_range_us"  => nil
}

require 'securerandom'

default['ruby']['packages'] = %w{ libxml2-dev libxslt-dev libmysqlclient-dev nodejs avahi-daemon libnss-mdns }

# config/settings.yml
default['alm_report']['settings'] = {
  "mode"                => "default",
  "solr_url"            => "http://api.plos.org/search",
  "url"                 => "http://alm.plos.org",
  "api_key"             => SecureRandom.hex(20),
  "username"            => nil,
  "password"            => nil,
  "secret_token"        => SecureRandom.hex(34)
}

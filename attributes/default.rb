require 'securerandom'

default['ruby']['packages'] = %w{ libxml2-dev libxslt-dev libmysqlclient-dev nodejs npm avahi-daemon libnss-mdns }
default['ruby']['user'] = 'vagrant'
default['ruby']['group'] = 'vagrant'
default['ruby']['rails_env'] = "development"
default['ruby']['db'] = { 'username' => 'vagrant', 'password' => SecureRandom.hex(10), 'host' => 'localhost' }

# config/settings.yml
default['alm_report']['settings'] = {
  "mode"                => "default",
  "solr_url"            => "http://api.plos.org/search",
  "search"              => "plos",
  "url"                 => "http://alm.plos.org",
  "api_key"             => SecureRandom.hex(20),
  "username"            => nil,
  "password"            => nil,
  "secret_token"        => SecureRandom.hex(34)
}

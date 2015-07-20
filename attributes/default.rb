default['ruby']['packages'] = %w{ curl git libmysqlclient-dev python-software-properties software-properties-common nodejs }
default['ruby']['packages'] += %w{ avahi-daemon libnss-mdns } if ENV['RAILS_ENV'] != "production"
default["dotenv"] = "default"
default["application"] = "alm-report"
default['ruby']['merge_slashes_off'] = true
default['ruby']['api_only'] = false
default['nodejs']['repo'] = 'https://deb.nodesource.com/node_0.12'
default['nodejs']['npm_packages'] = [{ "name" => "phantomjs" },
                                     { "name" => "istanbul"},
                                     { "name" => "codeclimate-test-reporter" }]

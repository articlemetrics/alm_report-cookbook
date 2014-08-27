name              "alm-report"
maintainer        "Martin Fenner"
maintainer_email  "mfenner@plos.org"
license           "Apache 2.0"
description       "Configures ALM Reports application"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.3.0"
depends           "apt", "~> 2.5.3"
depends           "build-essential", "2.0.0"
depends           "ruby", "~> 0.1.0"
depends           "mysql"
depends           "database"
depends           "passenger_nginx"
depends           "memcached"
depends           "phantomjs"
depends           "capistrano"

%w{ ubuntu }.each do |platform|
  supports platform
end

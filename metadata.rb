name              "alm_report"
maintainer        "Martin Fenner"
maintainer_email  "mfenner@plos.org"
license           "Apache 2.0"
description       "Configures ALM Reports application"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.0.5"

# opscode cookbooks
depends           "apt"
depends           "memcached"
depends           "mysql"
depends           "database", "~> 2.3.1"
depends           "nodejs"
depends           "phantomjs"

# our own cookbooks
depends           "ruby", "~> 0.6.0"
depends           "dotenv", "~> 0.2.0"
depends           "passenger_nginx", "~> 0.5.0"
depends           "mysql_rails", "~> 0.3.0"
depends           "capistrano", "~> 0.8.0"

%w{ ubuntu }.each do |platform|
  supports platform
end

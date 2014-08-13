name              "alm-report"
maintainer        "Martin Fenner"
maintainer_email  "mfenner@plos.org"
license           "Apache 2.0"
description       "Configures ALM Reports server"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.1.16"
depends           "git"
depends           "mysql"
depends           "database"
depends           "phantomjs"
depends           "passenger_apache2"

%w{ ubuntu }.each do |platform|
  supports platform
end

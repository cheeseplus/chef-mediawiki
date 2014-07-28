name             "mediawiki"
maintainer       "Millisami"
maintainer_email "millisami@gmail"
license          "Apache 2.0"
description      "Installs/Configures MediaWiki"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.2.0"

depends "mysql"
depends "apache2"
depends "php"
depends "database"
depends "imagemagick"
depends "git"

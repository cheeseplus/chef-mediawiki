#
# Cookbook Name:: mediawiki
# Attributes:: default
#
default['mediawiki']['base_url'] = 'http://releases.wikimedia.org/mediawiki/1.23'
default['mediawiki']['version'] = '1.23.2'
default['mediawiki']['filename'] = "mediawiki-#{node['mediawiki']['version']}.tar.gz"

default['mediawiki']['doc_root'] = '/var/www/mediawiki'
default['mediawiki']['domain'] = 'mediawiki-berkshelf.com'

default['mediawiki']['wgSitename'] = 'mediawiki'
default['mediawiki']['wgMetaNamespace'] = 'Mediawiki'
default['mediawiki']['wgScriptPath'] = '/w'
default['mediawiki']['wgScriptExtension'] = '.php'
default['mediawiki']['wgServer'] = "http://#{node['ipaddress']}"
default['mediawiki']['wgStylePath'] = '$wgScriptPath/skins'
default['mediawiki']['wgArticlePath'] = "/wiki/$1";
default['mediawiki']['wgLogo'] = '$wgStylePath/common/images/wiki.png'
default['mediawiki']['wgEnableEmail'] = 'true'
default['mediawiki']['wgEnableUserEmail'] = 'true'
default['mediawiki']['wgEmergencyContact'] = 'root@localhost'
default['mediawiki']['wgPasswordSender'] = 'root@localhost'
default['mediawiki']['wgEnotifUserTalk'] = 'false'
default['mediawiki']['wgEnotifWatchlist'] = 'false'
default['mediawiki']['wgEmailAuthentication'] = 'true'

# edit permissions
default['mediawiki']['wgGroupPermissions']['everyone'] = false;
default['mediawiki']['wgGroupPermissions']['user'] = true;
default['mediawiki']['wgGroupPermissions']['sysop'] = true;

# database settings
default['mediawiki']['wgDBtype'] = 'mysql'
default['mediawiki']['wgDBserver'] = 'localhost'
default['mediawiki']['wgDBname'] = 'mediawiki'
default['mediawiki']['wgDBuser'] = 'mediawiki'
default['mediawiki']['wgDBpassword'] = 'sekret'
default['mediawiki']['wgDBprefix'] = ''

default['mediawiki']['wgMainCacheType'] = 'CACHE_NONE'
default['mediawiki']['wgMemCachedServers'] = 'array()'
default['mediawiki']['wgEnableUploads'] = 'false'
default['mediawiki']['wgUseImageMagick'] = 'false'
default['mediawiki']['wgImageMagickConvertCommand'] = '/usr/bin/convert'
default['mediawiki']['wgUseInstantCommons'] = 'false'
default['mediawiki']['wgShellLocale'] = 'en_US.utf8'
default['mediawiki']['wgLanguageCode'] = 'en'
default['mediawiki']['wgSecretKey'] = ''
default['mediawiki']['wgUpgradeKey'] = ''
default['mediawiki']['wgDefaultSkin'] = 'vector'
default['mediawiki']['wgEnableCreativeCommonsRdf'] = 'false'
default['mediawiki']['wgRightsPage'] = ''
default['mediawiki']['wgRightsUrl'] = ''
default['mediawiki']['wgRightsText'] = ''
default['mediawiki']['wgRightsIcon'] = ''
default['mediawiki']['wgDiff3'] = '/usr/bin/diff3'
default['mediawiki']['wgResourceLoaderMaxQueryLength'] = '-1'

default['mediawiki']['dbAdminUser']       = 'admin'
default['mediawiki']['installdbPass']    = node['mysql']['server_root_password']
default['mediawiki']['dbAdminPass']       = 'sekret'

default['mediawiki']['backup_folder'] = '/var/backup/mediawiki'
default['mediawiki']['backup_frequency'] = 'weekly'

default['mediawiki']['access2config_folder'] = 'false'

default['mediawiki']['userLocalSettings'] = ['']

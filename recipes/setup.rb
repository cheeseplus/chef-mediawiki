#
# Cookbook Name:: mediawiki
# Recipe:: setup
#

package 'libmysqlclient-dev'

include_recipe 'mysql::server'
include_recipe 'database::mysql'
include_recipe 'git'

if node.attribute?('ec2')
  include_recipe 'mysql::server_ec2'
end

service 'mysql' do
  action :enable
end

include_recipe 'apache2'
include_recipe 'php'
include_recipe 'php::module_mysql'
include_recipe 'apache2::mod_php5'

execute 'install pear mail package' do
  command 'pear install mail'
  action :run
  not_if "pear list | awk '/Mail/ { print $1 }'"
end

execute 'install pear net_smtp package' do
  command 'pear install net_smtp'
  action :run
  not_if "pear list | awk '/Net_SMTP/ { print $1 }'"
end

package 'php-apc'
node.set['php']['ext_conf_dir']  = '/etc/php5/mods-available'

template "#{node['php']['ext_conf_dir']}/apc.ini" do
  source 'apc.ini.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(name: 'apc', extensions: ['apc.so'], directives: { 'shm_size' => '256M' })
  action action
end

userName = node['apache']['user']
groupName = node['apache']['group']

semver = node['mediawiki']['version'].split('.', 3)
major = semver[0].to_s
minor = semver[1].to_s
patch = semver[2].to_s

mediawiki_url = "#{node['mediawiki']['base_url']}/mediawiki-#{node['mediawiki']['version']}.tar.gz"
local_file = "#{Chef::Config['file_cache_path']}/mediawiki-#{node['mediawiki']['version']}.tar.gz"

remote_file local_file do
  source mediawiki_url
  owner userName
  group groupName
  mode 00755
  #  not_if {File.exists?(local_file)}
end

directory node['mediawiki']['directory'] do
  owner userName
  group groupName
  mode 00755
  action :create
  recursive true
end

execute 'untar-mediawiki' do
  cwd node['mediawiki']['directory']
  command "tar --strip-components 1 -xzf #{local_file}"
  creates node['mediawiki']['directory'] + '/api.php'
  user userName
  group groupName
end

directory node['mediawiki']['directory'] + '/config' do
  owner userName
  group groupName
  mode '0755'
end

directory node['mediawiki']['directory'] + '/mw-config' do
  owner userName
  group groupName
  mode '0755'
end


template node['mediawiki']['directory'] + '/LocalSettings.php' do
 source 'LocalSettings.php.erb'
end

web_app node['mediawiki']['domain'] do
  server_name node['mediawiki']['domain']
  server_aliases [node['ipaddress'], node['fqdn']]
  docroot node['mediawiki']['directory']
end

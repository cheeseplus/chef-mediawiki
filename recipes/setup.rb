#
# Cookbook Name:: mediawiki
# Recipe:: setup
#

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

include_recipe "apache2"
include_recipe "mysql::server"
include_recipe "php"
include_recipe "php::module_mysql"
include_recipe "apache2::mod_php5"

userName=node[:apache][:user]
groupName=node[:apache][:group]

local_file = "#{Chef::Config[:file_cache_path]}/mediawiki-1.20.5.tar.gz"
unless File.exists?(local_file)
  remote_file local_file do
    source "http://download.wikimedia.org/mediawiki/1.20/mediawiki-1.20.5.tar.gz"
    # source "http://download.wikimedia.org/mediawiki/1.17/mediawiki-1.17.0.tar.gz"
    owner userName
    group groupName
    mode 00755
  end
end

directory node['mediawiki']['directory'] do
  owner userName
  group groupName
  mode 00755
  action :create
  recursive true
end

execute "untar-mediawiki" do
  cwd node['mediawiki']['directory']
  command "tar --strip-components 1 -xzf #{local_file}"
  creates node[:mediawiki][:directory]+"/LocalSettings.php"
  user userName
  group groupName
end

directory node[:mediawiki][:directory]+"/config" do
  owner userName
  group groupName
  mode "0755"
  only_if {node[:mediawiki][:access2config_folder]=="true"}
end

directory node[:mediawiki][:directory]+"/mw-config" do
  owner userName
  group groupName
  mode "0755"
  only_if {node[:mediawiki][:access2config_folder]=="true"}
end

directory node[:mediawiki][:directory]+"/config" do
  owner userName
  group groupName
  mode "0400"
  only_if {node[:mediawiki][:access2config_folder]=="false"}
end

directory node[:mediawiki][:directory]+"/mw-config" do
  owner userName
  group groupName
  mode "0400"
  only_if {node[:mediawiki][:access2config_folder]=="false"}
end

web_app node['mediawiki']['domain'] do
  server_name node['mediawiki']['domain']
  server_aliases Array(node['ipaddress'], node['fqdn'])
  docroot node['mediawiki']['directory']
end


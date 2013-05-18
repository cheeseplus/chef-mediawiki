#
# Cookbook Name:: mediawiki
# Recipe:: database
#

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

include_recipe "mysql::client"
include_recipe "mysql::ruby"

node.set_unless[:mediawiki][:installdbPass] = node[:mysql][:server_root_password]
node.set_unless[:mediawiki][:wgDBpassword]  = secure_password
node.set_unless[:mediawiki][:dbAdminPass]   = secure_password
node.set_unless[:mediawiki][:wgSecretKey]   = secure_password
node.set_unless[:mediawiki][:wgUpgradeKey]  = secure_password

mysql_connection_info = {:host => "localhost",
                         :username => 'root',
                         :password => node['mysql']['server_root_password']}

mysql_database node['mediawiki']['wgDBname'] do
  connection mysql_connection_info
  action :create
end

node.default['mediawiki']['wgScriptPath'] = ""

execute "set permission on the #{node['mediawiki']['directory']}" do
  command "chown -R #{node[:apache][:user]}:#{node[:apache][:group]} #{node[:mediawiki][:directory]}"
  action :run
end

# grant all privileges on all tables for this db
mysql_database_user node['mediawiki']['wgDBuser'] do
  connection mysql_connection_info
  database_name node['mediawiki']['wgDBname']
  privileges [:all]
  password node['mediawiki']['wgDBpassword']
  action [:create, :grant]
end

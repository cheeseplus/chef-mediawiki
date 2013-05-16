#
# Cookbook Name:: mediawiki
# Recipe:: database
#

include_recipe "mysql::client"
include_recipe "mysql::ruby"

node.set_unless[:mediawiki][:installdbPass] = node[:mysql][:server_root_password]
node.set_unless[:mediawiki][:wgDBpassword]  = secure_password
node.set_unless[:mediawiki][:dbAdminPass]   = secure_password
node.set_unless[:mediawiki][:wgSecretKey]   = secure_password
node.set_unless[:mediawiki][:wgUpgradeKey]  = secure_password

# template "/tmp/set_pass.sql" do
#   source "set_pass.sql.erb"
#   owner "root"
#   group "root"
#   mode "0640"
#   not_if do
#     require 'rubygems'
#     Gem.clear_paths
#     require 'mysql'
#     m = Mysql.new(node['mediawiki']['wgDBserver'], "root", node['mysql']['server_root_password'])
#     m.list_dbs.include?(node['mediawiki']['wgDBname'])
#   end
# end

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

# script "set_mediawiki" do
#   interpreter "bash"
#   user "root"
#   cwd node[:mediawiki][:directory]
#   not_if {
#     File.exists?(node[:mediawiki][:directory]+"/LocalSettings.php")
#   }
#   code <<-EOH
#   chown -R #{node[:apache][:user]}:#{node[:apache][:group]} #{node[:mediawiki][:directory]}
#   cd #{node[:mediawiki][:directory]}
#   php maintenance/install.php --dbname #{node[:mediawiki][:wgDBname]} --dbpass #{node[:mediawiki][:wgDBpassword]}  --dbserver #{node[:mediawiki][:wgDBserver]} --dbuser #{node[:mediawiki][:wgDBuser]} --installdbpass #{node[:mediawiki][:installdbPass]}  --pass #{node[:mediawiki][:dbAdminPass]} --installdbuser root --lang #{node[:mediawiki][:wgLanguageCode]}  #{node[:mediawiki][:wgSitename]} #{node[:mediawiki][:dbAdminUser]}

#   mysql -u root -p#{node[:mediawiki][:installdbPass]} < /tmp/set_pass.sql
#   # mv LocalSettings.php LocalSettings_autogenerate.php
#   EOH
# end

# template node[:mediawiki][:directory]+"/LocalSettings.php" do
#   source "LocalSettings.php.erb"
#   owner node['apache']['user']
#   group node['apache']['group']
#   mode "0640"
# end


node.default['mediawiki']['wgDBpassword'] = "sekret"

# grant all privileges on all tables for this db
mysql_database_user node['mediawiki']['wgDBuser'] do
  connection mysql_connection_info
  database_name node['mediawiki']['wgDBname']
  privileges [:all]
  password node['mediawiki']['wgDBpassword']
  action [:create, :grant]
end

# execute "mysql-install-mediawiki-privileges" do
#   command "/usr/bin/mysql -u root -p\"#{node['mysql']['server_root_password']}\" < #{node['mysql']['conf_dir']}/mediawiki-grants.sql"
#   action :nothing
# end

# template "#{node['mysql']['conf_dir']}/mediawiki-grants.sql" do
#   source "grants.sql.erb"
#   owner "root"
#   group "root"
#   mode "0600"
#   variables(
#     :user     => node['mediawiki']['wgDBuser'],
#     :password => node['mediawiki']['wgDBpassword'],
#     :database => node['mediawiki']['wgDBname']
#   )
#   notifies :run, "execute[mysql-install-mediawiki-privileges]", :immediately
# end

#
# Cookbook Name:: mediawiki
# Recipe:: restore
#
# Copyright 2011, ccat
#

remote_file Chef::Config['file_cache_path'] + '/backup.sql.tar.gz' do
  source node['mediawiki']['db_backup_url'] 
  mode 00755
end

execute 'untar-db-backup' do
  cwd Chef::Config['file_cache_path']
  command "tar xzf backup.sql.tar.gz"
end

script 'restore_mediawiki_by_sql' do
  interpreter 'bash'
  user 'root'
  cwd Chef::Config['file_cache_path']
  only_if { File.exist?(Chef::Config['file_cache_path'] + '/backup.sql') }
  code <<-EOH
  mysql -u #{node['mediawiki']['wgDBuser']} -p#{node['mediawiki']['wgDBpassword']} #{node['mediawiki']['wgDBname']} < #{Chef::Config['file_cache_path']}/backup.sql
  EOH
end

# script 'restore_mediawiki_by_tar_gz' do
#   interpreter 'bash'
#   user 'root'
#   cwd node['mediawiki']['directory']
#   only_if { File.exist?(node['mediawiki']['directory'] + '/backup.tar.gz') }
#   code <<-EOH
#   cd #{node['mediawiki']['directory']}
#   tar xvzf backup.tar.gz
#   chown -R apache:apache images
#   chown -R apache:apache skins
#   chown -R apache:apache extensions
#   php maintenance/importDump.php backup.xml
#   php maintenance/rebuildrecentchanges.php
#   rm -rf backup.xml
#   rm -rf backup.tar.gz
#   EOH
# end

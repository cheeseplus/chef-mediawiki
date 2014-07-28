#
# Cookbook Name:: mediawiki
# Recipe:: default
#

include_recipe 'imagemagick'
include_recipe 'mediawiki::setup'
include_recipe 'mediawiki::database'

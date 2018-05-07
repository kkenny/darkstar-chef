#
# Cookbook:: thelinux_pro_blog
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

tag('web-server')

include_recipe 'base'
include_recipe 'jekyll'

file "#{node['jekyll']['deploy_directory']}/_site/host.txt" do
  content node['name']
  owner 'root'
  group 'root'
  mode 0755
  action :create
end

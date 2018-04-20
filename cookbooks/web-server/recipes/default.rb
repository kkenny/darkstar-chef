#
# Cookbook:: web-server
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

package 'httpd'

service 'httpd' do
  action [:start, :enable]
end

file '/var/www/html/index.html' do
  owner 'root'
  group 'root'
  mode 0644
  action :create
  content "#{node[:name]}"
end


#
# Cookbook:: web-server
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

package 'httpd'

service 'httpd' do
  action [:start, :enable]
end

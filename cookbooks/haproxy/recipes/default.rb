#
# Cookbook:: haproxy
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

package 'haproxy'

template '/etc/haproxy/haproxy.conf' do
  source 'haproxy.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  action :create
end

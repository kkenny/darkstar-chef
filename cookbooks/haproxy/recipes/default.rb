#
# Cookbook:: haproxy
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

package 'haproxy'

service 'haproxy' do
  action [:start, :enable]
end

template '/etc/haproxy/haproxy.cfg' do
  source 'haproxy.cfg.erb'
  owner 'root'
  group 'root'
  mode 0644
  action :create
  notifies :restart, 'service[haproxy]', :immediately
end

#
# Cookbook:: keepalived
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

execute "sysctl" do
  command 'sysctl -p'
  action :nothing
end

execute "add_nonlocal_bind" do
  command 'echo "net.ipv4.ip_nonlocal_bind=1" >> /etc/sysctl.conf'
  action :run
  not_if 'grep "net.ipv4.ip_nonlocal_bind=1" /etc/sysctl.conf'
  notifies :run, 'execute[sysctl]', :immediately
end

package 'keepalived'

service 'keepalived' do
  action [ :start, :enable ]
end

template '/etc/keepalived/keepalived.conf' do
  source 'keepalived.conf.erb'
  action :create
  notifies :restart, 'service[keepalived]', :immediately
end


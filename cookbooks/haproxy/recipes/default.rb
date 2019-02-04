#
# Cookbook:: haproxy
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

package 'haproxy'

service 'haproxy' do
  action [:start, :enable]
end


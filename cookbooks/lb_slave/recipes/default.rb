#
# Cookbook:: lb_slave
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

include_recipe 'haproxy::default'
include_recipe 'keepalived::default'

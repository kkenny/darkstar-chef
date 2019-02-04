#
# Cookbook:: lb_slave
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

include_recipe 'lb_slave::default'
include_recipe 'haproxy::pulp'

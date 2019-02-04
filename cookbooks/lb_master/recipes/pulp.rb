#
# Cookbook:: lb_master
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

include_recipe 'lb_master::default'
include_recipe 'haproxy::pulp'

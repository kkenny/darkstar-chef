#
# Cookbook:: lb_master
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

include_recipe 'base::default'
include_recipe 'haproxy::default'
include_recipe 'keepalived::default'

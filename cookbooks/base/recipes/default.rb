#
# Cookbook:: base
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

include_recipe 'default-packages'
include_recipe 'chef-client'
include_recipe 'chef-client::delete_validation'

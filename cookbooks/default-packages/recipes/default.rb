#
# Cookbook:: default-packages
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

include_recipe 'yum-epel'

packages = 'bash wget curl nmon'

packages.each do |pkg|
  package pkg do
    action :upgrade
  end
end

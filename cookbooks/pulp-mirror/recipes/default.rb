yum_repository 'epel-release' do
  description 'Extra Packages for Enterprise Linux 7 - $basearch'
  baseurl     node['pulp_server']['epel_baseurl']
  gpgkey      node['pulp_server']['epel_gpgkey']
  gpgcheck    true
  action      :create
end

include_recipe 'pulp_server::default'

execute 'pulp-gen-key-pair' do
  command 'pulp-gen-key-pair'
  creates '/etc/pki/pulp/rsa.key'
  action :run
end

execute 'pulp-gen-ca-certificate' do
  command 'pulp-gen-ca-certificate'
  creates '/etc/pki/pulp/ca.crt'
  action :run
end

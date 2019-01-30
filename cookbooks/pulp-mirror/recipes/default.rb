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

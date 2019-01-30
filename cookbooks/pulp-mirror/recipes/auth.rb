# Really secure... i know.

execute 'pulp-admin-login' do
  command 'pulp-admin login -u admin -p admin'
  creates '/root/.pulp/user-cert.pem'
  action :run
end

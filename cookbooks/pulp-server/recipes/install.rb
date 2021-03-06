#
# Cookbook:: pulp-server
# Recipe:: default
#

package 'epel-release'

remote_file '/etc/yum.repos.d/rhel-pulp.repo' do
  source 'https://repos.fedorapeople.org/repos/pulp/pulp/rhel-pulp.repo'
  owner 'root'
  group 'root'
  mode 0644
  action :create
end

%w(mongodb-server qpid-cpp-server qpid-cpp-server-linearstore pulp-server python-gofer-qpid python2-qpid qpid-tools pulp-rpm-plugins pulp-puppet-plugins pulp-docker-plugins pulp-admin-client pulp-rpm-admin-extensions pulp-puppet-admin-extensions pulp-docker-admin-extensions httpd).each do |pkg|
  package pkg
end

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

%w(mongod qpidd httpd ).each do |svc|
  service svc do
    action [ :enable, :start ]
  end
end

template '/etc/pulp/admin/conf.d/server.conf' do
  source 'pulp-admin-server.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  action :create
end

execute 'pulp-manage-db' do
  command 'sudo -u apache pulp-manage-db'
  creates '/etc/pulp-db-managed'
  action :run
  notifies :create, 'file[/etc/pulp-db-managed]', :immediately
end

%w(pulp_workers pulp_celerybeat pulp_resource_manager).each do |svc|
  service svc do
    action :enable
    subscribes :start, 'execute[pulp-manage-db]', :immediately
  end
end


file '/etc/pulp-db-managed' do
  owner 'root'
  group 'root'
  mode 0444
  action :nothing
end

execute 'pulp-admin-login' do
  command 'pulp-admin login -u admin -p admin'
  creates '/root/.pulp/user-cert.pem'
  action :run
end



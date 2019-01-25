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

execute 'something' do
  command 'this/that'
  creates '/path/to/file'
  action :run
  user 'root'
end

execute 'pulp-gen-key-pair' do
  command 'pulp-gen-key-pair'
  creates '/etc/pki/pulp/rsa.key'
  action :run
end

execute 'pulp-gen-ca-cert' do
  command 'pulp-gen-ca-cert'
  creates '/etc/pki/pulp/ca.crt'
  action :run
end

execute 'pulp-manage-db' do
  command 'pulp-manage-db'
  creates '/etc/pulp-db-managed'
  user 'apache'
  action :run
  notifies :create, 'file[/etc/pulp-db-managed]', :immediately
end

file '/etc/pulp-db-managed' do
  owner 'root'
  group 'root'
  mode 0444
  action :nothing
end

%w(mongod qpidd httpd pulp_workers pulp_celerybeat pulp_resource_manager).each do |svc|
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

execute 'pulp-admin-login' do
  command 'pulp-admin login'
  creates '/root/.pulp/user-cert.pem'
  action :run
end


# Create repos
repos = data_bag('pulp_repos')

repos.each do |repo|
  bag = data_bag_item('pulp_repos', repo)

  execute 'create_repo' do
    command "pulp-admin rpm repo create --repo-id #{bag['id']} --display-name #{bag['display_name']} --description \"#{bag['description']}\" --feed #{bag['feed']} --serve-http #{bag['serve_http'].to_string} --serve-https #{bag['serve_https'].to_string}"
    action :run
    notifies :run, 'execute[initialize-repo-content]', :immediately
    only_if bag['enabled'].true
    not_if "pulp-admin rpm repo list | grep #{bag['id']}"
  end

  execute 'initialize-repo-content' do
    command "pulp-admin rpm repo sync --repo-id #{bag['id']} --bg"
    action :nothing
    notifies :run, 'execute[publish-repo]', :immediately
  end

  execute 'publish-repo' do
    command "pulp-admin rpm repo publish run --repo-id #{bag['id']} --bg"
    action :nothing
  end
end


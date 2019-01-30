# # encoding: utf-8

# Inspec test for recipe pulp::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
  # This is an example test, replace with your own test.
  describe user('root'), :skip do
    it { should exist }
  end
end

# This is an example test, replace it with your own test.
describe port(80), :skip do
  it { should_not be_listening }
end

%w{ mongodb-server qpid-cpp-server qpid-cpp-server-linearstore pulp-server python-gofer-qpid python2-qpid qpid-tools pulp-rpm-plugins pulp-puppet-plugins pulp-docker-plugins pulp-admin-client pulp-rpm-admin-extensions pulp-puppet-admin-extensions pulp-docker-admin-extensions httpd }.each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

%w{ mongod qpidd httpd pulp_workers pulp_celerybeat pulp_resource_manager }.each do |svc|
  describe service(svc) do
    it { should be_running }
    it { should be_enabled }
  end
end

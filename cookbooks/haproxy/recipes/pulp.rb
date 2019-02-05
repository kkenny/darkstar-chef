include_recipe 'haproxy::default'


webservers = search(:node, 'tags:yum-mirror')

template '/etc/haproxy/haproxy.cfg' do
  source 'haproxy.cfg.erb'
  owner 'root'
  group 'root'
  mode 0644
  action :create
  notifies :restart, 'service[haproxy]', :immediately
  variables(webservers: webservers)
end

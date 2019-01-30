tag('pulp-main-master')

include_recipe 'pulp-mirror::default'


# Create repos
repos = data_bag('pulp_library')

repos.each do |repo|
  bag = data_bag_item('pulp_library', repo)

  pulp_rpm_repo bag['id'] do
    display_name bag['display_name']
    description bag['description']
    feed bag['feed']
    http bag['serve_http']
    https bag['serve_https']
    pulp_cert_verify false
    relative_url bag['relative_url']
    action [:create, :sync] if bag['enabled']
    notifies :touch, file["#{Chef::Config['file_cache_path']}/#{bag['id']}.sync", :immediately
  end

  pulp_rpm_repo bag['id'] do
    display_name bag['display_name']
    description bag['description']
    feed bag['feed']
    http bag['serve_http']
    https bag['serve_https']
    pulp_cert_verify false
    relative_url bag['relative_url']
    action :sync if file_age("#{Chef::Config['file_cache_path']}/#{bag['id']}.sync") > node['pulp-mirror']['sync']['cadence']
    notifies :touch, file["#{Chef::Config['file_cache_path']}/#{bag['id']}.sync", :immediately
  end

  pulp_rpm_repo bag['id'] do
    display_name bag['display_name']
    description bag['description']
    feed bag['feed']
    http bag['serve_http']
    https bag['serve_https']
    pulp_cert_verify false
    relative_url bag['relative_url']
    action :publish if bag['enabled']
    not_if { File.exist?("#{Chef::Config['file_cache_path']}/#{bag['id']}.published") }
    notifies :touch, file["#{Chef::Config['file_cache_path']}/#{bag['id']}.published", :immediately
  end

  file "#{Chef::Config['file_cache_path']}/#{bag['id']}.sync" do
    action :nothing
  end

  file "#{Chef::Config['file_cache_path']}/#{bag['id']}.published" do
    action :nothing
  end
end


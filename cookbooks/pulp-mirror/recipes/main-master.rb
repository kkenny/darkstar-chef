tag('pulp-main-master')

include_recipe 'pulp-mirror::default'


# Create repos
repos = data_bag('pulp_library')

repos.each do |repo|
  bag = data_bag_item('pulp_library', repo)

  # This feels *really* strange
  if bag['enabled']
    file "#{Chef::Config['file_cache_path']}/#{bag['id']}.created" do
      action :create
      notifies :create, pulp_rpm_repos[bag['id']], :immediately
    end

    file "#{Chef::Config['file_cache_path']}/#{bag['id']}.synced" do
      action :touch if file_age("#{Chef::Config['file_cache_path']}/#{bag['id']}.sync") > node['pulp-mirror']['sync']['cadence'] || not File.exist?("#{Chef::Config['file_cache_path']}/#{bag['id']}.sync")
      notifies :sync, pulp_rpm_repos[bag['id']], :immediately
    end

    file "#{Chef::Config['file_cache_path']}/#{bag['id']}.published" do
      action :create
      notifies :publish, pulp_rpm_repos[bag['id']], :immediately
    end
  end

  if not bag['enabled']
    file "#{Chef::Config['file_cache_path']}/#{bag['id']}.created" do
      action :delete
      notifies :delete, pulp_rpm_repos[bag['id']], :immediately
    end

    file "#{Chef::Config['file_cache_path']}/#{bag['id']}.synced" do
      action :delete
    end

    file "#{Chef::Config['file_cache_path']}/#{bag['id']}.published" do
      action :delete
    end
  end

  pulp_rpm_repo bag['id'] do
    display_name bag['display_name']
    description bag['description']
    feed bag['feed']
    http bag['serve_http']
    https bag['serve_https']
    pulp_cert_verify false
    relative_url bag['relative_url']
    action :nothing
  end
end


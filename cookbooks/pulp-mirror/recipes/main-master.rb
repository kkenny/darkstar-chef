tag('pulp-main-master')

include_recipe 'pulp-mirror::default'
include_recipe 'pulp-mirror::auth'


# Create repos
repos = data_bag('pulp_library')

repos.each do |repo|
  bag = data_bag_item('pulp_library', repo)

  # This feels *really* strange
  if bag['enabled']
    if !File.exist?("#{Chef::Config['file_cache_path']}/#{bag['id']}.sync")
      pulp_rpm_repo bag['id'] do
	display_name bag['display_name']
	description bag['description']
	feed bag['feed']
	http bag['serve_http']
	https bag['serve_https']
	pulp_cert_verify false
	relative_url bag['relative_url']
	action [:create,:sync,:publish]
      end

      # This *assumes* the last op was good
      file "#{Chef::Config['file_cache_path']}/#{bag['id']}.sync" do
	action :touch
      end
    end

    if File.exist?("#{Chef::Config['file_cache_path']}/#{bag['id']}.sync")
      pulp_rpm_repo bag['id'] do
	display_name bag['display_name']
	description bag['description']
	feed bag['feed']
	http bag['serve_http']
	https bag['serve_https']
	pulp_cert_verify false
	relative_url bag['relative_url']
	action :sync if file_age("#{Chef::Config['file_cache_path']}/#{bag['id']}.sync") > node['pulp-mirror']['sync']['cadence']
      end
    end
  end

  if !bag['enabled']
    pulp_rpm_repo bag['id'] do
      action :delete
    end
  end
end

bundles = data_bag('pulp_bundles')

bundles.each do |bundle|
  bag = data_bag_item('pulp_bundles', bundle)

  if bag['enabled']
    pulp_rpm_repo bag['id'] do
      display_name bag['display_name']
      description bag['description']
      http bag['serve_http']
      https bag['serve_https']
      pulp_cert_verify false
      relative_url bag['relative_url']
      action :create
    end

    if !File.exist?("#{Chef::Config['file_cache_path']}/#{bag['source']}_#{bag['id']}.cloned")
      execute "clone-bundle-#{bag['id']}" do
	command "pulp-admin rpm repo copy all --from-repo-id #{bag['source']} --to-repo-id #{bag['id']}"
	action :run
      end

      # This *assumes* the last op was good
      file "#{Chef::Config['file_cache_path']}/#{bag['source']}_#{bag['id']}.cloned" do
	action :touch
      end
    end
  end

  pulp_rpm_repo bag['id'] do
    display_name bag['display_name']
    description bag['description']
    http bag['serve_http']
    https bag['serve_https']
    pulp_cert_verify false
    relative_url bag['relative_url']
    action :publish
    only_if "pulp-admin rpm repo list --detail --repo-id #{bag['id']} | grep 'Last Publish' | grep 'None'"
  end

  if !bag['enabled']
    pulp_rpm_repo bag['id'] do
      action :delete
    end
  end
end

env_repos = data_bag('pulp_env_repos')

env_repos.each do |env_repo|
  bag = data_bag_item('pulp_env_repos', env_repo)

  if bag['enabled']
    pulp_rpm_repo bag['id'] do
      display_name bag['display_name']
      description bag['description']
      http bag['serve_http']
      https bag['serve_https']
      pulp_cert_verify false
      relative_url bag['relative_url']
      action :create
    end

    if !File.exist?("#{Chef::Config['file_cache_path']}/#{bag['source']}_#{bag['id']}.cloned")
      execute "clone-bundle-#{bag['id']}" do
	command "pulp-admin rpm repo copy all --from-repo-id #{bag['source']} --to-repo-id #{bag['id']}"
	action :run
      end

      # This *assumes* the last op was good
      file "#{Chef::Config['file_cache_path']}/#{bag['source']}_#{bag['id']}.cloned" do
	action :touch
      end
    end
  end

  if !File.exist?("#{Chef::Config['file_cache_path']}/#{bag['source']}_#{bag['id']}.published")
    pulp_rpm_repo bag['id'] do
      display_name bag['display_name']
      description bag['description']
      http bag['serve_http']
      https bag['serve_https']
      pulp_cert_verify false
      relative_url bag['relative_url']
      action :publish
    end

    # This *assumes* the last op was good
    file "#{Chef::Config['file_cache_path']}/#{bag['source']}_#{bag['id']}.published" do
      action :touch
    end
  end

  if !bag['enabled']
    pulp_rpm_repo bag['id'] do
      action :delete
    end
  end
end

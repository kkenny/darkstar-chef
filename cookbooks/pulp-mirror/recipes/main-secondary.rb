tag('pulp-main-secondary')

include_recipe 'pulp-mirror::default'
include_recipe 'pulp-mirror::auth'

pulp_master = search(:node, 'tags:pulp-main-master')

# Create repos

env_repos = data_bag('pulp_env_repos')

env_repos.each do |env_repo|
  bag = data_bag_item('pulp_env_repos', env_repo)

  if bag['enabled']
    if !File.exist?("#{Chef::Config['file_cache_path']}/#{bag['id']}.sync")
      pulp_rpm_repo bag['id'] do
	display_name bag['display_name']
	description bag['description']
	feed 'http://' + pulp_master.first['network']['interfaces']['eth1']['addresses'].keys[1] + '/pulp/repos/' + bag['relative_url']
	http bag['serve_http']
	https bag['serve_https']
	pulp_cert_verify false
	relative_url bag['relative_url']
	action [:create,:sync,:publish]
      end

      file "#{Chef::Config['file_cache_path']}/#{bag['source']}_#{bag['id']}.sync" do
	action :touch
      end
    end

   if File.exist?("#{Chef::Config['file_cache_path']}/#{bag['id']}.sync")
      pulp_rpm_repo bag['id'] do
        display_name bag['display_name']
        description bag['description']
	feed 'http://' + pulp_master.first['network']['interfaces']['eth1']['addresses'].keys[1] + '/pulp/repos/' + bag['relative_url']
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

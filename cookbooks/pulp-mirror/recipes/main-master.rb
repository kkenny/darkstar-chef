tag('pulp-main-master')

include_recipe 'pulp-mirror::default'


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


  if !bag['enabled']
    pulp_rpm_repo bag['id'] do
      action :delete
    end
  end
end

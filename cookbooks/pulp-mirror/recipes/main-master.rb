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
    ssl_validation false
    pulp_cert_verify false
    action [:create, :sync, :publish] if bag['enabled']
  end
end





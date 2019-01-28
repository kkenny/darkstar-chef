tag('pulp-main-master')

include_recipe 'pulp-server::install'


# Create repos
repos = data_bag('pulp_library')

repos.each do |repo|
  bag = data_bag_item('pulp_library', repo)

  execute 'create_repo' do
    command "pulp-admin rpm repo create --repo-id #{bag['id']} --display-name \"#{bag['display_name']}\" --description \"#{bag['description']}\" --feed #{bag['feed']} --serve-http #{bag['serve_http'].to_s} --serve-https #{bag['serve_https'].to_s}"
    action :run
    notifies :run, 'execute[initialize-repo-content]', :immediately
    only_if { bag['enabled'].to_s == "true" }
    not_if "pulp-admin rpm repo list | grep #{bag['id']}"
  end

  execute 'initialize-repo-content' do
    command "pulp-admin rpm repo sync run --repo-id #{bag['id']} --bg"
    action :nothing
    notifies :run, 'execute[publish-repo]', :immediately
  end

  execute 'publish-repo' do
    command "pulp-admin rpm repo publish run --repo-id #{bag['id']} --bg"
    action :nothing
  end
end

bundles = data_bag('pulp_bundles')

bundles.each do |bundle|
  bag = data_bag_item('pulp_bundles', bundle)

  execute 'create_bundle_repo' do
    command "pulp-admin rpm repo create --repo-id #{bag['id']} --display-name \"#{bag['display_name']}\" --description \"#{bag['description']}\" --serve-http #{bag['serve_http'].to_s} --serve-https #{bag['serve_https'].to_s}"
    action :run
    notifies :run, 'execute[clone_bundle]', :immediately
    only_if { bag['enabled'].to_s == "true" }
    not_if "pulp-admin rpm repo list | grep #{bag['id']}"
  end

  execute 'clone_bundle' do
    command "pulp-admin rpm repo copy rpm --from-repo-id #{bag['source']} --to-repo-id #{bag['id']} --bg"
    action :nothing
    notifies :run, 'execute[publish-bundle]', :immediately
  end

  execute 'publish-bundle' do
    command "pulp-admin rpm repo publish run --repo-id #{bag['id']} --bg"
    action :nothing
  end
end

stack_repos = data_bag('pulp_stack_repos')

stack_repos.each do |stack_repo|
  bag = data_bag_item('pulp_stack_repos', stack_repo)

  execute 'create_stack_repo' do
    command "pulp-admin rpm repo create --repo-id #{bag['id']} --display-name \"#{bag['display_name']}\" --description \"#{bag['description']}\" --serve-http #{bag['serve_http'].to_s} --serve-https #{bag['serve_https'].to_s}"
    action :run
    notifies :run, 'execute[clone_stack_repo]', :immediately
    only_if { bag['enabled'].to_s == "true" }
    not_if "pulp-admin rpm repo list | grep #{bag['id']}"
  end

  execute 'clone_stack_repo' do
    command "pulp-admin rpm repo copy rpm --from-repo-id #{bag['source']} --to-repo-id #{bag['id']}--bg"
    action :nothing
    notifies :run, 'execute[publish-stack-repo]', :immediately
  end

  execute 'publish-stack-repo' do
    command "pulp-admin rpm repo publish run --repo-id #{bag['id']} --bg"
    action :nothing
  end
end




tag('pulp-stack-master')

include_recipe 'pulp-server::install'


# Create repos
repos = data_bag('pulp_repos')

repos.each do |repo|
  bag = data_bag_item('pulp_repos', repo)

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


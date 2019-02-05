tag('yum-mirror')

package 'httpd'

service 'httpd' do
  action [:start,:enable]
end

pulp_master = search(:node, 'tags:pulp-main-master')

env_repos = data_bag('pulp_env_repos')

env_repos.each do |env_repo|
  bag = data_bag_item('pulp_env_repos', env_repo)

  reposync_mirror bag['id'] do
    baseurl 'http://' + pulp_master.first['network']['interfaces']['eth1']['addresses'].keys[1] + '/pulp/repos/' + bag['relative_url']
    update 'chef'
    dest_dir node['yum_mirror']['pub_dir']
    action :create
  end
end

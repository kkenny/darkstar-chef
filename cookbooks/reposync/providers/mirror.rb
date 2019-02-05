#
# Cookbook Name::	reposync
# Description::		Provider to mirror rpm repositories
# Recipe::				mirror
# Author::        Jeremy MAURO (j.mauro@criteo.com)
#
#
#
use_inline_resources if defined?(use_inline_resources)

def whyrun_supported?
  true
end

def creating_repository
  repo_file = ::File.join(new_resource.conf_dir, new_resource.reponame)
  if new_resource.repofile
    Chef::Log.debug('Repofile is provided')
    remote_file repo_file do
      owner 'root'
      group 'root'
      mode '0644'
      source new_resource.repofile
      action :create
    end
  elsif new_resource.baseurl
    Chef::Log.debug('Baseurl is provided')
    template repo_file do
      source 'repofile.erb'
      cookbook new_resource.cookbook
      owner 'root'
      group 'root'
      mode '0644'
      variables(name:    new_resource.reponame,
                baseurl: new_resource.baseurl,)
      action :create
    end
  else
    raise 'Reposync resource should at least specify "baseurl" or a "repofile"'
  end
end

def updating_repository
  repo_file    = ::File.join(new_resource.conf_dir, new_resource.reponame)
  reposync_cmd = "reposync -q #{new_resource.cmd_args} --config='#{repo_file}' -r #{new_resource.reponame} --download_path='#{new_resource.dest_dir}'"
  case new_resource.update
  when /(?i-mx:daily)/, /(?i-mx:weekly)/
    cron "Cron job update: #{new_resource.reponame}" do
      hour new_resource.hour
      minute new_resource.minute
      weekday new_resource.weekday
      command "[ -f '#{repo_file}' ] && \
        yum -q -c '#{repo_file}' clean all --disablerepo=* --enablerepo=#{new_resource.reponame} > /dev/null 2>&1 && \
        #{reposync_cmd} > /dev/null 2>&1"
    end
  when /(?i-mx:chef)/
    execute "Updating #{new_resource.reponame} repository" do
      environment 'PATH' => "#{ENV['PATH']}:/usr/bin:/bin"
      timeout new_resource.timeout.to_i
      command "yum -q -c '#{repo_file}' clean all --disablerepo=* --enablerepo='#{new_resource.reponame}' && #{reposync_cmd}"
      only_if "[ -f '#{repo_file}' ]"

      action :run
    end
  end
end

action :create do
  package 'yum-utils'
  [new_resource.conf_dir, new_resource.dest_dir].each do |d|
    directory d
  end
  creating_repository
  updating_repository
end

action :delete do
  # --[ remove config file ]--
  file ::File.join(new_resource.conf_dir, new_resource.reponame) do
    action :delete
  end

  # --[ Remove cron ]--
  cron "Cron job update: #{new_resource.reponame}" do
    action :delete
  end

  # --[ Remove mirrorring repository ]--
  directory ::File.join(new_resource.dest_dir, new_resource.reponame) do # ~FC021
    recursive true
    action :delete
    only_if { new_resource.remove_repo }
  end
end

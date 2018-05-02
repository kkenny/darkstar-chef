default['jekyll']['deploy_directory']	= '/var/www/thelinux.pro'
default['jekyll']['repository']		= 'https://github.com/kkenny/thelinux_pro.git'
default['jekyll']['user']		= 'root'
default['jekyll']['group']		= 'root'
default['jekyll']['domain_name']	= 'thelinux.pro'
default['jekyll']['packages']		= ['git', 'rubygem-bundler', 'ruby-devel', 'gcc' ]
default['jekyll']['command']		= '/usr/local/bin/jekyll'
default['jekyll']['options']		= ['serve', '--detach']

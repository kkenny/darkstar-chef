#
# Cookbook Name::	reposync
# Description::		'mirror' resource
# Recipe::				mirror
# Author::        Jeremy MAURO (j.mauro@criteo.com)
#
#
#
actions :create, :remove

default_action :create

attribute :reponame, kind_of: String, name_attribute: true
attribute :repofile, regex: [%r{^(?i-mx:http://)}, %r{^(?i-mx:ftp://)}, %r{^(?i-mx:file://)}]
attribute :baseurl, regex: [%r{^(?i-mx:http://)}, %r{^(?i-mx:ftp://)}, %r{^(?i-mx:file://)}]
attribute :cookbook, kind_of: String, default: 'reposync'
attribute :update, regex: [/(?i-mx:daily)/, /(?i-mx:weekly)/, /(?i-mx:chef)/], default: 'daily'
attribute :hour, kind_of: String, default: '*'
attribute :minute, kind_of: String, default: '0'
attribute :weekday, kind_of: String, default: '0'
attribute :timeout, kind_of: String, default: '7200'
attribute :remove_repo, kind_of: [TrueClass, FalseClass], default: true
attribute :conf_dir, kind_of: String, default: '/etc/reposync.d'
attribute :dest_dir, kind_of: String, default: '/var/opt/reposync'
attribute :cmd_args, kind_of: [String, nil], default: nil

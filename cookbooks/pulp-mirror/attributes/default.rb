default['pulp_server']['install_admin_client']	= true
default['pulp_server']['install_mongodb']	= true
default['pulp_server']['install_qpid']		= true
default['pulp_server']['configure_repos']	= true
default['pulp_server']['configure_epel']	= true

default['pulp_server']['config']['database']	= {
  'verify_ssl' => false
}

default['pulp_server']['config']['servier']	= {
  'verify_ssl' => false
}

default['pulp_server']['admin']['server']	= {
  'verify_ssl' => false
}

name 'lb_master'
maintainer 'Kameron Kenny'
maintainer_email 'you@example.com'
license 'All Rights Reserved'
description 'Installs/Configures lb_master'
long_description 'Installs/Configures lb_master'
version '0.1.0'
chef_version '>= 12.14' if respond_to?(:chef_version)

depends 'keepalived'
depends 'haproxy'
depends 'default-packages'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/lb_master/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/lb_master'

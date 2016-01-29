name             'yum-cleanup'
maintainer       'RightScale Inc'
maintainer_email 'premium@rightscale.com'
license          'Apache 2.0'
description      'Installs/Configures yum-cleanup'
long_description 'Installs/Configures yum-cleanup'
version          '0.1.0'

recipe "yum-cleanup::default", "cleans up yum repo"


attribute 'yum-cleanup/org',
  :display_name => 'RHEL Org',
  :required => 'required'

attribute 'yum-cleanup/key',
  :display_name => 'RHEL Key',
  :required => 'required'

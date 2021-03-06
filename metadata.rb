name             'strongdm'
maintainer       'Applause App Quality, Inc.'
maintainer_email 'ops@applause.com'
license          'Apache-2.0'
description      'Installs and configures strongDM'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.5.8'

%w(redhat centos scientific amazon ubuntu debian suse).each do |os|
  supports os
end

source_url 'https://github.com/ApplauseOSS/strongdm_cookbook' if respond_to?(:source_url)
issues_url 'https://github.com/ApplauseOSS/strongdm_cookbook/issues' if respond_to?(:issues_url)
chef_version '>= 12.14' if respond_to?(:chef_version)

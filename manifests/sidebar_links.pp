# Take care of the sidebar-links plugin
class jenkins_additions::sidebar_links (
  $ensure = 'present',
) {

  $sidebar_link_xml = "${::jenkins::localstatedir}/sidebar-link.xml"

  jenkins::plugin { 'sidebar-link':
    version => $ensure,
  }

  if $ensure != 'absent' {
  
    file { "${::jenkins::localstatedir}/userContent":
      ensure => 'directory',
      owner  => $::jenkins::user,
      group  => $::jenkins::group,
      mode   => '0755',
    }

    concat { $sidebar_link_xml:
      ensure => $ensure,
      owner  => $::jenkins::user,
      group  => $::jenkins::group,
      mode   => '0644',
    }

    concat::fragment { 'sidebar-link-header':
      target  => $sidebar_link_xml,
      content => template('jenkins_additions/sidebar_link.xml-header.erb'),
      order   => '001',
    }
    concat::fragment { 'sidebar-link-footer':
      target  => $sidebar_link_xml,
      content => template('jenkins_additions/sidebar_link.xml-footer.erb'),
      order   => '100',
    }

  }

  Concat[$sidebar_link_xml] ~>
  Service['jenkins']


}

class jenkins_additions::sidebar_links (
  $ensure,
) {

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
  }


}

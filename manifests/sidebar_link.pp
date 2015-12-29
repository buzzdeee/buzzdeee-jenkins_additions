# A defined type to manage links for the sidebar-link
# plugin
define jenkins_additions::sidebar_link (
  $linkurl,
  $linktext,
  $linkicon_name,
  $linkicon_content = undef,  # allow to have multiple links with same icon
  $ensure = 'present',
) {

  include jenkins_additions::sidebar_links

  if $linkicon_content {
    file { "${::jenkins::localstatedir}/userContent/${linkicon_name}":
      ensure  => $ensure,
      owner   => $::jenkins::user,
      group   => $::jenkins::group,
      mode    => '0644',
      content => base64('decode', $linkicon_content),
    }
  }

  if $ensure == 'present' {
    concat::fragment { "sidebar-link-${linktext}":
      target  => "${::jenkins::localstatedir}/sidebar-link.xml",
      content => template('jenkins_additions/sidebar_link.xml-link.erb'),
      order   => '010',
    }
  }


}

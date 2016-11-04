# == Class: jenkins_additions
#
# Full description of class jenkins_additions here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'jenkins_additions':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
class jenkins_additions (
  $jenkins_url,
  $jenkins_path = undef,
  $admin_address,
  $jabber_enabled = 'false',
  $jabber_port = '5222',
  $jabber_jid = 'jenkins@example.com',
  $jabber_password = 'password',
  $jabber_nickname = 'jenkins',
  $jabber_expose_presence = 'true',
  $jabber_accept_all_certs = 'false',
  $jabber_scramble_passwords = 'true',
  $jabber_command_prefix = '!',
  $jabber_default_suffix = '',
  $jabber_subscription_mode = 'accept_all',
  $jabber_email_address_jabber_id = 'false',
  $jabber_proxy_type = 'NONE',
  $jabber_proxy_port = '3128',
) {

  include jenkins

  $jabber_encoded_password = base64('encode', $jabber_password)

  file { "${::jenkins::localstatedir}/jenkins.model.JenkinsLocationConfiguration.xml":
    owner   => "${::jenkins::user}",
    group   => "${::jenkins::group}",
    mode    => '0644',
    content => template('jenkins_additions/jenkins.model.JenkinsLocationConfiguration.xml.erb'),
  }
  file { "${::jenkins::localstatedir}/hudson.plugins.jabber.im.transport.JabberPublisher.xml":
    owner   => "${::jenkins::user}",
    group   => "${::jenkins::group}",
    mode    => '0644',
    content => template('jenkins_additions/hudson.plugins.jabber.im.transport.JabberPublisher.xml.erb'),
  }

  Package[$::jenkins::package_name] ->
  File["${::jenkins::localstatedir}/jenkins.model.JenkinsLocationConfiguration.xml"] ~>
  File["${::jenkins::localstatedir}/hudson.plugins.jabber.im.transport.JabberPublisher.xml"] ~>
  Service['jenkins']

}

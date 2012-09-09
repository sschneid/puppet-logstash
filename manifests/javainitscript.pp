# templated java daemon script
define logstash::javainitscript (
  $servicename = $title,
  $serviceuser,
  $servicegroup = $serviceuser,
  $servicehome,
  $serviceuserhome = $servicehome,
  $servicelogfile,
  $servicejar,
  $serviceargs
) {

  file { "/etc/init.d/${servicename}":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0755',
    content => template('logstash/javainitscript.erb')
  }
}

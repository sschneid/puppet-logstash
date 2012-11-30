define logstash::sharedconfig::add_config($template='', $order=1) {

  if (empty($template)) {
    $content = template($name)
  } else {
    $content = template($template)
  }

  if (!defined(File['/etc/logstash'])) {
    file { '/etc/logstash':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
    }
  }

  concat::fragment { "logstash_addconfig_${name}":
    target  => '/etc/logstash/shipper.conf',
    order   => $order,
    content => $content 
  }
}

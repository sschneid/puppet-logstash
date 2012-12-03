# = Class: logstash::shipper::sharedconfig
#
# Description of logstash::shipper:sharedconfig
#
# == Parameters:
#
# $logstash_server: The address of the logstash server.
#
# == Actions:
#
# Generates the Logstash shipper configuration. The benefit of a shared configuration is, that other modules are able to 
# add Logstash configuration units. Three defines are provided to add filter, input or output configurations:
#
# * logstash::shipper::add_filter
# * logstash::shipper::add_input
# * logstash::shipper::add_output
#
# The disadvantage of this appraoch is that such modules are no longer loosely coupled and require this Logstash module.
#
# == Requires:
#
# puppet-concat (see https://github.com/ripienaar/puppet-concat)
#
# == Sample Usage:
#
# == Todo:
#
class logstash::shipper::sharedconfig (
  $logstash_server,
  $configfile,
  $params = {}
) {

  Class['logstash::config'] -> Class['logstash::shipper::sharedconfig']

  concat { $configfile:
    owner  => '0',
    group  => '0',
    mode   => '0644',
    order  => 'numeric',
    notify => Service['logstash-shipper']
  }

  case  $logstash::config::logstash_transport {
    /^redis$/: {
      $output_conf = "redis { host => \"${logstash::config::redis_host}\" data_type => \"list\" key => \"logstash\" }"
    }
    /^amqp$/:  {
      $output_conf = "amqp { host => \"${logstash_server}\" exchange_type => \"fanout\" name => \"rawlogs\" }"
    }
    default: {
      $output_conf = '' 
    }
  }

  concat::fragment {
    'inputs':
      target  => $configfile,
      content => "input {\n",
      order   => 0;
    'filter':
      target  => $configfile,
      content => "}\n\nfilter {\n",
      order   => 101;
    'output':
      target  => $configfile,
      content => "}\n\noutput {\n${output_conf}\n",
      order   => 201;
    'close':
      target  => $configfile,
      content => "\n}",
      order   => 999
  }

}

# = Class: logstash::shipper
#
# Description of logstash::shipper
#
# == Parameters:
#
# $param::   description of parameter. default value if any.
#
# == Actions:
#
# Describe what this class does. What gets configured and how.
#
# == Requires:
#
# Requirements. This could be packages that should be made available.
#
# == Sample Usage:
#
# == Todo:
#
# * Update documentation
#
class logstash::shipper::defaultconfig (
  $logstash_server,
  $configfile,
  $params={
    logfiles => '"/var/log/messages", "/var/log/syslog", "/var/log/*.log"'
  }
) {

  Class['logstash::config'] -> Class['logstash::shipper']

  case  $logstash::config::logstash_transport {
    /^redis$/: { $shipper_conf_content = template('logstash/shipper-input.conf.erb',
                                                  'logstash/shipper-filter.conf.erb',
                                                  'logstash/shipper-output-redis.conf.erb') }
    /^amqp$/:  { $shipper_conf_content = template('logstash/shipper-input.conf.erb',
                                                  'logstash/shipper-filter.conf.erb',
                                                  'logstash/shipper-output-amqp.conf.erb') }
    default:   { $shipper_conf_content = undef }
  }

   file { $configfile:
    ensure  => 'file',
    group   => '0',
    mode    => '0644',
    owner   => '0',
    content => $shipper_conf_content
  }
}

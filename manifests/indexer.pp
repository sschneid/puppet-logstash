# = Class: logstash::indexer
#
# Description of logstash::indexer
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
class logstash::indexer (
) {

  # make sure the logstash::common class is declared before logstash::server
  Class['logstash::common'] -> Class['logstash::indexer']

  
  User  <| tag == 'logstash' |>
  Group <| tag == 'logstash' |>

  $jarname = $logstash::common::logstash_jar
  $verbose = $logstash::common::logstash_verbose

  # create the config file based on the transport we are using (this could also be extended to use different configs)
  case  $logstash::common::logstash_transport {
    /^redis$/: { $indexer_conf_content = template('logstash/indexer-input-redis.conf.erb', 
						  'logstash/indexer-filter.conf.erb', 
						  'logstash/indexer-output.conf.erb') }
    /^amqp$/:  { $indexer_conf_content = template('logstash/indexer-input-amqp.conf.erb',
                                                  'logstash/indexer-filter.conf.erb',
                                                  'logstash/indexer-output.conf.erb') }
    default:   { $indexer_conf_content = template('logstash/indexer-input-amqp.conf.erb',
                                                  'logstash/indexer-filter.conf.erb',
                                                  'logstash/indexer-output.conf.erb') }
  }

  file { "$logstash::common::logstash_etc/indexer.conf":
    ensure  => 'file',
    group   => '0',
    mode    => '0644',
    owner   => '0',
    content  => $indexer_conf_content,
  }

  # alternative startup script
  logstash::javainitscript { 'logstash-indexer':
    serviceuser    => $logstash::params::user,
    servicegroup   => $logstash::params::group,
    servicehome    => $logstash::common::logstash_home,
    servicelogfile => "$logstash::common::logstash_log/indexer.log",
    servicejar     => $logstash::package::jar,
    serviceargs    => " agent -f $logstash::common::logstash_etc/indexer.conf -l $logstash::common::logstash_log/indexer.log", 
  }

  service { 'logstash-indexer':
    ensure    => 'running',
    hasstatus => true,
    enable    => true,
    require   => [ Logstash::Javainitscript['logstash-indexer'], Class['logstash::package'] ],
  }

}


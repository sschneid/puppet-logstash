# = Class: logstash::web
#
# Description of logstash::web
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
class logstash::web (
) {

  # make sure the logstash::common class is declared before logstash::indexer
  Class['logstash::common'] -> Class['logstash::web']

  User  <| tag == 'logstash' |>
  Group <| tag == 'logstash' |>

  # startup script
  logstash::javainitscript { 'logstash-web':
    serviceuser    => 'logstash',
    servicegroup   => 'logstash',
    servicehome    => $logstash::common::logstash_home,
    servicelogfile => "$logstash::common::logstash_log/web.log",
    servicejar     => $logstash::package::jar,
    serviceargs    => " web -l $logstash::common::logstash_log/web.log",
  }

  service { 'logstash-web':
    ensure    => 'running',
    hasstatus => true,
    enable    => true,
    require   => Logstash::Javainitscript['logstash-web'],
  }

}


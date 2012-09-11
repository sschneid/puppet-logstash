# = Class: logstash::redis
#
# Manage installation & configuration of a redis server (to be used by logstash)
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
class logstash::redis (
) {

  # make sure the logstash::common class is declared before logstash::server
  Class['logstash::common'] -> Class['logstash::redis']

  if $logstash::common::redis_provider == 'package' {
   
    # build a package-version if we need to 
    $redis_package = $logstash::common::redis_version ? {
      /\d+./  => "$logstash::common::redis_package-$logstash::common::redis_version",
      default => "$logstash::common::redis_package",
    }

    package { $redis_package:
      ensure => present,
    }

    # uor redis config file
    file { '/etc/redis.conf':
      ensure => present,
      content => template('logstash/redis.conf.erb'),
      require   => Package["$redis_package"],
    }
  
    service { 'redis':
      ensure    => 'running',
      hasstatus => true,
      enable    => true,
      subscribe => File['/etc/redis.conf'],
      require   => File['/etc/redis.conf'],
    }
  }
}


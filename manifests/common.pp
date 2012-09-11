# = Class: logstash::common
#
# Description of logstash::common
#
# == Actions:
#
# Primarily a config class for logstash
#
# == Requires:
#
# Requirements. This could be packages that should be made available.
#
# == Sample Usage:
# redis_provider = package|external
#		   package  - we'll declare and ensure a redis package, using $redis_version
#		   external - assume redis is being installed outside of this module
# == Todo:
#
# * Update documentation
#
class logstash::common ( $logstash_home = "/usr/local/logstash", 
 			 $logstash_etc = "/etc/logstash",
			 $logstash_log = "/var/log/logstash",
			 $logstash_transport = 'amqp',
			 $logstash_jar_provider = 'package',
			 $logstash_verbose = 'no',
			 $elasticsearch_provider = 'external',
			 $redis_provider = 'external',
			 $redis_package = 'redis',
			 $redis_version = '2.4.15',
			 $redis_host = '127.0.0.1',
			 $redis_port = '6379',
			 $redis_key = 'logstash'
		       ) {

  # create parent directory and all folders beneath it.

  file { "$logstash_home":
    ensure   => 'directory',
  }

  file { "$logstash_home/bin/":
    ensure => 'directory',
    require => File["$logstash_home"],
  }
  file { "$logstash_home/lib/":
    ensure => 'directory',
    require => File["$logstash_home"],
  }

  file { "$logstash_etc":
    ensure  => 'directory',
  }

  file { "$logstash_log":
    ensure   => 'directory',
    recurse  => true,
  }

  # make sure we have a logstash jar  
  class { 'logstash::package':
    logstash_home => $logstash_home,
    logstash_provider => $logstash_jar_provider
  }

  class { 'logstash::user': logstash_homeroot => $logstash::common::logstash_home }
}


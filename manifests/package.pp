class logstash::package($logstash_version = '1.1.1',
			$logstash_provider = 'http',
			$logstash_home = '/usr/local/logstash',
			$java_package = 'java-1.6.0-openjdk' ) {


  $logstash_jar = sprintf("%s-%s-%s", "logstash", $logstash_version, "monolithic.jar")
  $jar = "$logstash_home/$logstash_jar"

  # put the logstash jar somewhere
  # logstash_provider = package|puppet|http

  # if we're using a package as the logstash jar provider,
  # pull in the package we need
  if $logstash_provider == 'package' {
    # Obviously I abused fpm to create a logstash package and put it on my
    # repository
    package { 'logstash':
      ensure => 'latest',
    }
  }

  # You'll need to drop the jar in place on your puppetmaster
  # (puppetmaster file sharing isn't a great way to shift 50Mb+ files around)
  if $logstash_provider == 'puppet' {
    file { "$logstash_home/$logstash_jar":
      ensure => present,
      source => "puppet:///modules/logstash/$logstash_jar",
    }
  }

  if $logstash_provider == 'http' {
    $logstash_baseurl = "http://semicomplete.com/files/logstash/"
    $logstash_url = "$logstash_baseurl/$logstash_jar"

    # pull in the logstash jar over http
    exec { "curl -o $logstash_home/$logstash_jar $logstash_url":
      cwd     => "/tmp",
      creates => "$logstash_home/$logstash_jar",
      path    => ["/usr/bin", "/usr/sbin"],
    }
  }

  if $logstash_provider == 'external' {
    notify { "It's up to you to provde $logstash_jar": }
  }

  # mundane required packages in the std repo
  #package { 'jdk-1.6.0_26-fcs': }
  package { "$java_package": }
}

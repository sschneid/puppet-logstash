#puppet-logstash#

* Simple puppet logstash module, tries to take care of making sure redis &
elasticsearch are available.
* Supports grabbing logstash jar directly (jar's are packages right?  we just don't support them natively yet :-))
* aimed at logstash-1.1 or newer, with simple redis setup
* templated init scripts for all java daemons (based on work by Josh Davis/Christian d'Heureuse)

##Usage##

Declare a config class that is used by the working classes:

```puppet
  class { 'logstash::config':
    logstash_home => '/opt/logstash',
    logstash_jar_provider => 'http',
    logstash_transport => 'redis',
    redis_provider     => 'package',
  }
```
Then just apply the required classes to each node:
```puppet
  # indexer/storage node
  class { 'logstash::indexer': }
  # use this class to provide transport that matches what we want, optional
  class { 'logstash::redis': }
  
  # straight log shipper only
  class { 'logstash::shipper': }

  # web interface
  class { 'logstash::web': }
```

##Configuration Detail##

Many of the configuration defaults come from the original behaviour of Kris Buytaert's original module, which this started out as a fork of.



#Credit#
Based on lots of original work by Kris Buytaert & Joe McDonagh 
https://github.com/KrisBuytaert/puppet-logstash
https://github.com/thesilentpenguin/puppet-logstash


define logstash::sharedconfig::add_output($template='') {
  logstash::sharedconfig::add_config { $name:
    template => $template,
    order    => 300
  }
}


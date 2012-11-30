define logstash::sharedconfig::add_input($template='') {
  logstash::sharedconfig::add_config { $name:
    template => $template,
    order    => 100
  }
}

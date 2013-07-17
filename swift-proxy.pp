class { 'swift::proxy':
  proxy_local_net_ip       => '127.0.0.1',
  package_ensure           => 'present',
}

class { 'swift::proxy::catch_errors' :}

class { 'swift::proxy::healthcheck' :}

class { 'swift::proxy::swift3' :}

class { 'memcached' :}

class { 'swift::proxy::tempauth' :}

class { 'swift::proxy::cache':
  memcache_servers => '127.0.0.1',
}




  
  

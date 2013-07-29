import 'config.pp'

class { 'rsyslog::client':
  log_local => true,
  log_auth_local => true,
  rservers => $rservers,
}

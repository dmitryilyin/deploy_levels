class {'rsync::server':}

class { 'swift::storage::all':
  storage_local_net_ip => '127.0.0.1',
  swift_zone           => '1',
}

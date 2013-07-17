$ring_part_power          = '18'
$ring_replicas            = '3'
$ring_min_part_hours      = '1'

$nodes = [
  {
    'name' => 'storage-01',
    'role' => 'storage',
    'internal_address' => '127.0.0.1',
    'public_address'   => '127.0.0.1',
    'swift_zone'       => '1',
    'mountpoints'      => "1 2\n 2 1",
    'storage_local_net_ip' => '127.0.0.1',
  },
]

ring_devices {'all':
  storages => $nodes,
}

class { 'swift':
  swift_hash_suffix => 'secret',
  package_ensure    => 'present',
}

class { 'swift::ringbuilder':
  part_power     => $ring_part_power,
  replicas       => $ring_replicas,
  min_part_hours => $ring_min_part_hours,
}

class { 'swift::ringserver':
  local_net_ip => '127.0.0.1',
}

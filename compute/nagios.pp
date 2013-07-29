class {'nagios':
  proj_name       => 'test',
  services        => [
    'host-alive', 'nova-compute','nova-network','libvirt'
  ],
  whitelist       => [
    '127.0.0.1',
    'nagios-server.localdomain'
  ],
  hostgroup       => 'compute',
}

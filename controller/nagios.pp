class {'nagios':
  proj_name       => 'test',
  services        => [
    'host-alive','nova-novncproxy','keystone', 'nova-scheduler',
    'nova-consoleauth', 'nova-cert', 'nova-api', 'glance-api',
    'glance-registry','horizon', 'rabbitmq', 'mysql',
  ],
  whitelist       => [
    '127.0.0.1',
    'nagios-server.localdomain'
  ],
  hostgroup       => 'controller',
}

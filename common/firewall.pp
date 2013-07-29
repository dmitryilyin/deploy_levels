class {'openstack::firewall': }

# Workaround for fuel bug with firewall
firewall {'003 remote rabbitmq ':
  sport   => [ 4369, 5672, 41055, 55672, 61613 ],
  source  => $master_ip,
  proto   => 'tcp',
  action  => 'accept',
  require => Class['openstack::firewall'],
}

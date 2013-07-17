l23network::l3::ifconfig { 'eth0':
  ipaddr          => '192.168.122.2',
  netmask         => '255.255.255.0',
  dns_nameservers => ['192.168.122.1','8.8.8.8'],
  gateway         => '192.168.122.1',
}

l23network::l3::ifconfig { 'eth1':
  ipaddr  => '10.9.0.2',
  netmask => '255.255.0.0',
}

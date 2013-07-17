include stdlib

class { 'openstack::clocksync':
  ntp_servers => [ 'pool.ntp.org' ],
}

include ssh

class { 'openstack::mirantis_repos':
  type=>'default',
}

sysctl::value { 'net.ipv4.conf.all.rp_filter':
  value => '0',
}

package { 'rubygems':
  ensure => installed,
}

package { 'serverspec':
    ensure   => 'installed',
    provider => 'gem',
}

Package['rubygems'] -> Package['serverspec']

class { '::quantum':
      queue_provider  => $queue_provider,
      rabbit_host     => $rabbit_nodes ? { false => $rabbit_host, default => $rabbit_nodes },
      rabbit_user     => $rabbit_user,
      rabbit_password => $rabbit_password,
      qpid_host       => $qpid_nodes ? { false => $qpid_host, default => $qpid_nodes },
      qpid_user       => $qpid_user,
      qpid_password   => $qpid_password,
      verbose         => $verbose,
      debug           => $debug,
      use_syslog           => $use_syslog,
      syslog_log_level     => $syslog_log_level,
      syslog_log_facility  => $syslog_log_facility_quantum,
      rabbit_ha_virtual_ip => $rabbit_ha_virtual_ip,
      auth_host            => $auth_host,
      auth_tenant          => 'services',
      auth_user            => 'quantum',
      auth_password        => $quantum_user_password,
    }

    class { 'quantum::plugins::ovs':
      sql_connection      => $quantum_sql_connection,
      tenant_network_type => $tenant_network_type,
      enable_tunneling    => $enable_tunneling,
      bridge_mappings     => ['physnet2:br-prv'],
      network_vlan_ranges => "physnet1,physnet2:${segment_range}",
      tunnel_id_ranges    => "${segment_range}",
    }

    class { 'quantum::agents::ovs':
      bridge_uplinks   => ["br-prv:${private_interface}"],
      bridge_mappings  => ['physnet2:br-prv'],
      enable_tunneling => $enable_tunneling,
      local_ip         => $internal_address,
    }


    # script called by qemu needs to manipulate the tap device
    file { '/etc/libvirt/qemu.conf':
      ensure => present,
      notify => Service['libvirt'],
      source => 'puppet:///modules/nova/libvirt_qemu.conf',
    }

    # class { 'quantum::agents::dhcp':
    #   debug          => True,
    #   use_namespaces => $::quantum_use_namespaces,
    # }

    # class { 'quantum::agents::l3':
    #   debug          => True,
    #   auth_url       => "http://${service_endpoint}:35357/v2.0",
    #   auth_tenant    => 'services',
    #   auth_user      => 'quantum',
    #   auth_password  => $quantum_user_password,
    #   use_namespaces => $::quantum_use_namespaces,
    # }

    class { 'nova::compute::quantum': }

    # does this have to be installed on the compute node?
    # NOTE
    class { 'nova::network::quantum':
    #$fixed_range,
      quantum_admin_password    => $quantum_user_password,
    #$use_dhcp                  = 'True',
    #$public_interface          = undef,
      quantum_connection_host   => $quantum_host,
      quantum_auth_strategy     => 'keystone',
      quantum_url               => "http://${service_endpoint}:9696",
      quantum_admin_tenant_name => 'services',
      quantum_admin_username    => 'quantum',
      quantum_admin_auth_url    => "http://${service_endpoint}:35357/v2.0",
      public_interface          => $public_interface,
    }

    nova_config {
      'linuxnet_interface_driver':       value => 'nova.network.linux_net.LinuxOVSInterfaceDriver';
      'linuxnet_ovs_integration_bridge': value => 'br-int';
    }

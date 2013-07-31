  ######### Cinder Controller Services ########
  if $cinder {
    if !defined(Class['openstack::cinder']) {
      class {'openstack::cinder':
        sql_connection       => "mysql://${cinder_db_user}:${cinder_db_password}@${db_host}/${cinder_db_dbname}?charset=utf8",
        rabbit_password      => $rabbit_password,
        rabbit_host          => false,
        rabbit_nodes         => $rabbit_nodes,
        volume_group         => $cinder_volume_group,
        physical_volume      => $nv_physical_volume,
        manage_volumes       => $manage_volumes,
        enabled              => true,
        glance_api_servers   => "${service_endpoint}:9292",
        auth_host            => $service_endpoint,
        bind_host            => $api_bind_address,
        iscsi_bind_host      => $cinder_iscsi_bind_addr,
        cinder_user_password => $cinder_user_password,
        use_syslog           => $use_syslog,
        verbose              => $verbose,
        debug                => $debug,
        syslog_log_facility  => $syslog_log_facility_cinder,
        syslog_log_level     => $syslog_log_level,
        cinder_rate_limits   => $cinder_rate_limits,
        rabbit_ha_virtual_ip => $rabbit_ha_virtual_ip,
        queue_provider       => $queue_provider,
      qpid_password        => $qpid_password,
      qpid_user            => $qpid_user,
      qpid_nodes           => $qpid_nodes,
      } # end class
    } else { # defined
      if $manage_volumes {
      # Set up nova-volume
        class { 'nova::volume':
          ensure_package => $::openstack_version['nova'],
          enabled        => true,
        }
        class { 'nova::volume::iscsi':
          iscsi_ip_address => $api_bind_address,
          physical_volume  => $nv_physical_volume,
        }
      } #end manage_volumes
    } #end else
  } #end cinder

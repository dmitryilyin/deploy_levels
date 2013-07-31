  #
  # indicates that all nova config entries that we did
  # not specifify in Puppet should be purged from file
  #
  if ! defined( Resources[nova_config] ) {
    if ($purge_nova_config) {
      resources { 'nova_config':
        purge => true,
      }
    }
  }

  $final_sql_connection = $sql_connection
  $glance_connection = $glance_api_servers
  $rabbit_connection = $rabbit_host

  case $::osfamily {
    'RedHat': {
      augeas { 'sysconfig-libvirt':
        context => '/files/etc/sysconfig/libvirtd',
        changes => 'set LIBVIRTD_ARGS "--listen"',
        before  => Augeas['libvirt-conf'],
      }
    }
    'Debian': {
      augeas { 'default-libvirt':
        context => '/files/etc/default/libvirt-bin',
        changes => "set libvirtd_opts '\"-l -d\"'",
        before  => Augeas['libvirt-conf'],
      }
    }
  default: { fail("Unsupported osfamily: ${::osfamily}") }
  }

  augeas { 'libvirt-conf':
    context => '/files/etc/libvirt/libvirtd.conf',
    changes =>[
      'set listen_tls 0',
      'set listen_tcp 1',
      'set auth_tcp none',
    ],
    notify => Service['libvirt'],
  }

  $memcached_addresses =  inline_template("<%= @cache_server_ip.collect {|ip| ip + ':' + @cache_server_port }.join ',' %>")
  nova_config {'DEFAULT/memcached_servers':
    value => $memcached_addresses
  }
  class { 'nova':
      ensure_package       => $::openstack_version['nova'],
      sql_connection       => $sql_connection,
      queue_provider       => $queue_provider,
      rabbit_nodes         => $rabbit_nodes,
      rabbit_userid        => $rabbit_user,
      rabbit_password      => $rabbit_password,
      qpid_userid          => $qpid_user,
      qpid_password        => $qpid_password,
      qpid_nodes           => $qpid_nodes,
      qpid_host            => $qpid_host,
      image_service        => 'nova.image.glance.GlanceImageService',
      glance_api_servers   => $glance_api_servers,
      verbose              => $verbose,
      debug                => $debug,
      rabbit_host          => $rabbit_host,
      use_syslog           => $use_syslog,
      syslog_log_facility  => $syslog_log_facility,
      syslog_log_level     => $syslog_log_level,
      api_bind_address     => $internal_address,
      rabbit_ha_virtual_ip => $rabbit_ha_virtual_ip,
      state_path           => $state_path,
  }
  
  #Cinder setup
    $enabled_apis = 'metadata'
    package {'python-cinderclient': ensure => present}
    if $cinder and $manage_volumes {
      class {'openstack::cinder':
        sql_connection       => "mysql://${cinder_db_user}:${cinder_db_password}@${db_host}/${cinder_db_dbname}?charset=utf8",
        queue_provider       => $queue_provider,
        rabbit_password      => $rabbit_password,
        rabbit_host          => false,
        rabbit_nodes         => $rabbit_nodes,
        qpid_password        => $qpid_password,
        qpid_host            => false,
        qpid_nodes           => $qpid_nodes,
        volume_group         => $cinder_volume_group,
        physical_volume      => $nv_physical_volume,
        manage_volumes       => $manage_volumes,
        enabled              => true,
        glance_api_servers   => $glance_api_servers,
        auth_host            => $service_endpoint,
        bind_host            => false,
        iscsi_bind_host      => $cinder_iscsi_bind_addr,
        cinder_user_password => $cinder_user_password,
        verbose              => $verbose,
        debug                => $debug,
        use_syslog           => $use_syslog,
        syslog_log_facility  => $syslog_log_facility_cinder,
        syslog_log_level     => $syslog_log_level,
        cinder_rate_limits   => $cinder_rate_limits,
        rabbit_ha_virtual_ip => $rabbit_ha_virtual_ip,
      }
    }



  # Install / configure nova-compute
  class { '::nova::compute':
    ensure_package                => $::openstack_version['nova'],
    enabled                       => $enabled,
    vnc_enabled                   => $vnc_enabled,
    vncserver_proxyclient_address => $internal_address,
    vncproxy_host                 => $vncproxy_host,
  }

  # Configure libvirt for nova-compute
  class { 'nova::compute::libvirt':
    libvirt_type     => $libvirt_type,
    vncserver_listen => $internal_address,
  }
    case $::osfamily {
      'Debian': {$scp_package='openssh-client'}
      'RedHat': {$scp_package='openssh-clients'}
       default: {
                 fail("Unsupported osfamily: ${osfamily}")
      }
    }
    if !defined(Package[$scp_package]) {
      package {$scp_package: ensure => present }
    }

  if ( $ssh_private_key != undef ) {
   file { '/var/lib/nova/.ssh':
      ensure => directory,
      owner  => 'nova',
      group  => 'nova',
      mode   => '0700'
    }
    file { '/var/lib/nova/.ssh/authorized_keys':
      ensure => present,
      owner  => 'nova',
      group  => 'nova',
      mode   => '0400',
      source => $ssh_public_key,
    }
    file { '/var/lib/nova/.ssh/id_rsa':
      ensure => present,
      owner  => 'nova',
      group  => 'nova',
      mode   => '0400',
      source => $ssh_private_key,
    }
    file { '/var/lib/nova/.ssh/id_rsa.pub':
      ensure => present,
      owner  => 'nova',
      group  => 'nova',
      mode   => '0400',
      source => $ssh_public_key,
    }
    file { '/var/lib/nova/.ssh/config':
      ensure  => present,
      owner   => 'nova',
      group   => 'nova',
      mode    => '0600',
      content => "Host *\n  StrictHostKeyChecking no\n  UserKnownHostsFile=/dev/null\n",
    }
  }

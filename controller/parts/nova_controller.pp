######## BEGIN NOVA ###########
  #
  # indicates that all nova config entries that we did
  # not specifify in Puppet should be purged from file
  #
  if ($purge_nova_config) {
    resources { 'nova_config':
      purge => true,
    }
  }
  if ($cinder) {
    $enabled_apis = 'ec2,osapi_compute'
  }
  else {
    $enabled_apis = 'ec2,osapi_compute,osapi_volume'
  }

  class { 'openstack::nova::controller':
    # Database
    db_host                 => $db_host,
    # Network
    network_manager         => $network_manager,
    floating_range          => $floating_range,
    fixed_range             => $fixed_range,
    public_address          => $public_address,
    public_interface        => $public_interface,
    admin_address           => $admin_address,
    internal_address        => $internal_address,
    private_interface       => $private_interface,
    auto_assign_floating_ip => $auto_assign_floating_ip,
    create_networks         => $create_networks,
    num_networks            => $num_networks,
    network_size            => $network_size,
    multi_host              => $multi_host,
    network_config          => $network_config,
    keystone_host           => $service_endpoint,
    # Quantum
    quantum                 => $quantum,
    quantum_user_password   => $quantum_user_password,
    quantum_db_password     => $quantum_db_password,
    quantum_network_node    => $quantum_network_node,
    quantum_netnode_on_cnt  => $quantum_netnode_on_cnt,
    quantum_gre_bind_addr   => $quantum_gre_bind_addr,
    quantum_external_ipinfo => $quantum_external_ipinfo,
    segment_range           => $segment_range,
    tenant_network_type     => $tenant_network_type,
    # Nova
    nova_user_password      => $nova_user_password,
    nova_db_password        => $nova_db_password,
    nova_db_user            => $nova_db_user,
    nova_db_dbname          => $nova_db_dbname,
    # AMQP
    queue_provider          => $queue_provider,
    # Rabbit
    rabbit_user             => $rabbit_user,
    rabbit_password         => $rabbit_password,
    rabbit_nodes            => $rabbit_nodes,
    rabbit_cluster          => $rabbit_cluster,
    rabbit_node_ip_address  => $rabbit_node_ip_address,
    rabbit_port             => $rabbit_port,
    rabbit_ha_virtual_ip    => $rabbit_ha_virtual_ip,
    # Qpid
    qpid_password           => $qpid_password,
    qpid_user               => $qpid_user,
    #qpid_cluster            => $qpid_cluster,
    qpid_nodes              => $qpid_nodes,
    qpid_port               => $qpid_port,
    qpid_node_ip_address    => $qpid_node_ip_address,
    # Glance
    glance_api_servers      => $glance_api_servers,
    # General
    verbose                 => $verbose,
    debug                   => $debug,
    enabled                 => $enabled,
    exported_resources      => $export_resources,
    enabled_apis            => $enabled_apis,
    api_bind_address        => $api_bind_address,
    ensure_package          => $::openstack_version['nova'],
    use_syslog              => $use_syslog,
    syslog_log_facility     => $syslog_log_facility_nova,
    syslog_log_facility_quantum => $syslog_log_facility_quantum,
    syslog_log_level        => $syslog_log_level,
    nova_rate_limits        => $nova_rate_limits,
    cinder                  => $cinder
  }

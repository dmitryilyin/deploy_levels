import '../config.pp'

include osnailyfacter::test_compute

class { 'openstack::compute':
  public_interface       => $public_interface,
  private_interface      => $fixed_interface,
  internal_address       => $internal_address,
  libvirt_type           => $libvirt_type,
  fixed_range            => $fixed_network_range,
  network_manager        => $network_manager,
  network_config         => $network_config,
  multi_host             => $multi_host,
  sql_connection         => $sql_connection,
  nova_user_password     => $nova_hash[user_password],
  queue_provider         => $::queue_provider,
  rabbit_nodes           => [$controller_node_address],
  rabbit_password        => $rabbit_hash[password],
  rabbit_user            => $rabbit_user,
  auto_assign_floating_ip => $bool_auto_assign_floating_ip,
  qpid_nodes             => [$controller_node_address],
  qpid_password          => $rabbit_hash[password],
  qpid_user              => $rabbit_user,
  glance_api_servers     => "${controller_node_address}:9292",
  vncproxy_host          => $controller_node_public,
  vnc_enabled            => true,
  #ssh_private_key        => 'puppet:///ssh_keys/openstack',
  #ssh_public_key         => 'puppet:///ssh_keys/openstack.pub',
  quantum                => $quantum,
  #quantum_host           => $quantum_host,
  #quantum_sql_connection => $quantum_sql_connection,
  #quantum_user_password  => $quantum_user_password,
  #tenant_network_type    => $tenant_network_type,
  service_endpoint       => $controller_node_address,
  cinder                 => true,
  cinder_user_password   => $cinder_hash[user_password],
  cinder_db_password     => $cinder_hash[db_password],
  manage_volumes         => false,
  db_host                => $controller_node_address,
  verbose                => $verbose,
  use_syslog             => true,
  state_path             => $nova_hash[state_path],
}

nova_config { 'DEFAULT/start_guests_on_host_boot': value => $start_guests_on_host_boot }
nova_config { 'DEFAULT/use_cow_images': value => $use_cow_images }
nova_config { 'DEFAULT/compute_scheduler_driver': value => $compute_scheduler_driver }

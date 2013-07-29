import '../config.pp'

include osnailyfacter::test_controller

class { 'openstack::controller':
  admin_address           => $controller_node_address,
  public_address          => $controller_node_public,
  public_interface        => $public_interface,
  private_interface       => $fixed_interface,
  internal_address        => $controller_node_address,
  floating_range          => false,
  fixed_range             => $fixed_network_range,
  multi_host              => $multi_host,
  network_manager         => $network_manager,
  num_networks            => $num_networks,
  network_size            => $network_size,
  network_config          => $network_config,
  verbose                 => $verbose,
  auto_assign_floating_ip => $bool_auto_assign_floating_ip,
  mysql_root_password     => $mysql_hash[root_password],
  admin_email             => $access_hash[email],
  admin_user              => $access_hash[user],
  admin_password          => $access_hash[password],
  keystone_db_password    => $keystone_hash[db_password],
  keystone_admin_token    => $keystone_hash[admin_token],
  keystone_admin_tenant   => $access_hash[tenant],
  glance_db_password      => $glance_hash[db_password],
  glance_user_password    => $glance_hash[user_password],
  nova_db_password        => $nova_hash[db_password],
  nova_user_password      => $nova_hash[user_password],
  queue_provider          => $::queue_provider,
  rabbit_password         => $rabbit_hash[password],
  rabbit_user             => $rabbit_user,
  qpid_password           => $rabbit_hash[password],
  qpid_user               => $rabbit_user,
  export_resources        => false,
  quantum                 => $quantum,
  cinder                  => true,
  cinder_user_password    => $cinder_hash[user_password],
  cinder_db_password      => $cinder_hash[db_password],
  manage_volumes          => false,
  use_syslog              => true,
}

nova_config { 'DEFAULT/start_guests_on_host_boot': value => $start_guests_on_host_boot }
nova_config { 'DEFAULT/use_cow_images': value => $use_cow_images }
nova_config { 'DEFAULT/compute_scheduler_driver': value => $compute_scheduler_driver }

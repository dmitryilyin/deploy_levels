# configure nova api
  class { 'nova::api':
    ensure_package    => $::openstack_version['nova'],
    enabled           => true,
    admin_tenant_name => 'services',
    admin_user        => 'nova',
    admin_password    => $nova_user_password,
    enabled_apis      => $enabled_apis,
    cinder            => $cinder,
    auth_host         => $service_endpoint,
    nova_rate_limits  => $nova_rate_limits,
  }

  # if the compute node should be configured as a multi-host
  # compute installation
  if ! $quantum {
    if ! $fixed_range {
      fail('Must specify the fixed range when using nova-networks')
    }

    if $multi_host {
      include keystone::python

      nova_config {
        'DEFAULT/multi_host':      value => 'True';
        'DEFAULT/send_arp_for_ha': value => 'True';
        # 'DEFAULT/metadata_listen': value => $internal_address;
        'DEFAULT/metadata_host':   value => $internal_address;
      }

      if ! $public_interface {
        fail('public_interface must be defined for multi host compute nodes')
      }

      $enable_network_service = true

      if $auto_assign_floating_ip {
         nova_config { 'DEFAULT/auto_assign_floating_ip': value => 'True' }
      }


    } else {
      $enable_network_service = false

      nova_config {
        'DEFAULT/multi_host':      value => 'False';
        'DEFAULT/send_arp_for_ha': value => 'False';
      }
    }

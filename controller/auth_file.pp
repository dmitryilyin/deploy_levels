import 'config.pp'

class { 'openstack::auth_file':
  admin_user           => $access_hash[user],
  admin_password       => $access_hash[password],
  keystone_admin_token => $keystone_hash[admin_token],
  admin_tenant         => $access_hash[tenant],
  controller_node      => $controller_node_address,
}

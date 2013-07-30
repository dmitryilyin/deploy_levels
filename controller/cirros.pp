import '../config.pp'

class { 'openstack::img::cirros':
  os_username               => shellescape($access_hash[user]),
  os_password               => shellescape($access_hash[password]),
  os_tenant_name            => shellescape($access_hash[tenant]),
  img_name                  => 'TestVM',
  stage                     => 'glance-image',
}

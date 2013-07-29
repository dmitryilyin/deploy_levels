$openstack_version = {
  'keystone'   => 'latest',
  'glance'     => 'latest',
  'horizon'    => 'latest',
  'nova'       => 'latest',
  'novncproxy' => 'latest',
  'cinder'     => 'latest',
}

case $::operatingsystem {
  'redhat' : { 
          $queue_provider = 'qpid'
          $custom_mysql_setup_class = 'pacemaker_mysql'
  }
  default: {
    $queue_provider='rabbitmq'
    $custom_mysql_setup_class='galera'
  }
}

$network_config = {
  'vlan_start'     => $vlan_start,
}

$multi_host              = true
$quantum                 = false

$network_manager      = "nova.network.manager.${::network_manager_type}"

$nova_hash     = parsejson($::nova)
$mysql_hash    = parsejson($::mysql)
$rabbit_hash   = parsejson($::rabbit)
$glance_hash   = parsejson($::glance)
$keystone_hash = parsejson($::keystone)
$swift_hash    = parsejson($::swift)
$cinder_hash   = parsejson($cinder)
$access_hash   = parsejson($::access)
$extra_rsyslog_hash = parsejson($::syslog)
$floating_hash = parsejson($::floating_network_range)

if $auto_assign_floating_ip == 'true' {
  $bool_auto_assign_floating_ip = true
} else {
  $bool_auto_assign_floating_ip = false
}

$base_syslog_hash  = parsejson($::base_syslog)
$base_syslog_rserver  = {
  'remote_type' => 'udp',
  'server' => $base_syslog_hash['syslog_server'],
  'port' => $base_syslog_hash['syslog_port']
}

$syslog_hash   = parsejson($::syslog)
$syslog_rserver = {
  'remote_type' => $syslog_hash['syslog_transport'],
  'server' => $syslog_hash['syslog_server'],
  'port' => $syslog_hash['syslog_port'],
}

if $syslog_hash['syslog_server'] != "" and $syslog_hash['syslog_port'] != "" and $syslog_hash['syslog_transport'] != "" {
  $rservers = [$base_syslog_rserver, $syslog_rserver]
}
else {
  $rservers = [$base_syslog_rserver]
}

# do not edit the below line
validate_re($::queue_provider,  'rabbitmq|qpid')

$rabbit_user   = 'nova'

$sql_connection           = "mysql://nova:${nova_hash[db_password]}@${::controller_node_address}/nova"
$mirror_type = 'external'

$verbose = true
Exec { logoutput => true }

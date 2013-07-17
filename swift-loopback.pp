$storage_devices        = [1, 2]
$storage_base_dir       = '/srv/loopback-device'
$storage_mnt_base_dir   = '/srv/node'

swift::storage::loopback { $storage_devices:
  base_dir     => $storage_base_dir,
  mnt_base_dir => $storage_mnt_base_dir,
  seek         => '51200',
  byte_size    => '1024',
}

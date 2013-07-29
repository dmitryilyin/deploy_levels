package { 'gdb' :
  ensure => installed,
}

$script = '#!/bin/sh
PUPPET_PIDS=`ps ahxwww | grep ruby | grep -v grep | grep puppet | awk \'{ print $1 }\'`
for pid in ${PUPPET_PIDS}; do
  gdb --batch-silent -ex \'call rb_backtrace()\' -p "${pid}"
done'

file { '/usr/local/bin/puppet-trace' :
  ensure  => present,
  mode    => '0755',
  owner   => 'root',
  group   => 'root',
  content => $script,
}

file { '/usr/local/sbin/puppet-trace' :
  ensure => symlink,
  target => '/usr/local/bin/puppet-trace',
}

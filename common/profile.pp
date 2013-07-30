$colorcmd = 'if [[ ${EUID} == 0 ]] ; then
  PS1=\'\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\]$(__git_ps1) \'
else
  PS1=\'\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\]$(__git_ps1) \'
fi'

if $::osfamily == 'RedHat' {

  package { ['git','bash-completion'] :
    ensure => installed,
  }

	file { 'colorcmd.sh' :
	  ensure    => present,
	  owner     => 'root',
	  group     => 'root',
	  mode      => '0644',
	  path      => '/etc/profile.d/colorcmd.sh',
	  content   => $colorcmd,
	}

}

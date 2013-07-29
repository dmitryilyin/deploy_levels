require 'spec_helper'

describe command('ip addr list eth0') do
  it { should return_stdout /192\.168\.122\.2\/24/ }
end

describe command('ip route') do
  it { should return_stdout /default via 192\.168\.122\.1/ }
end

describe file('/etc/sysconfig/network-scripts/ifcfg-eth0') do
  it { should be_file }
  it { should contain 'DEVICE=eth0' }
  it { should contain 'IPADDR=192.168.122.2' }
  it { should contain 'NETMASK=255.255.255.0' }
  it { should contain 'DNS2=8.8.8.8' }
  it { should contain 'DNS1=192.168.122.1' }
  it { should contain 'GATEWAY=192.168.122.1' }
end



describe command('ip addr list eth1') do
  it { should return_stdout /10\.9\.0\.2\/16/ }
end

describe file('/etc/sysconfig/network-scripts/ifcfg-eth1') do
  it { should be_file }
  it { should contain 'DEVICE=eth1' }
  it { should contain 'IPADDR=10.9.0.2' }
  it { should contain 'NETMASK=255.255.0.0' }
end
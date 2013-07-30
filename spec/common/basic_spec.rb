require 'spec_helper'

describe package('ntp') do
  it { should be_installed }
end

describe service('ntpd') do
  it { should be_enabled }
end

describe service('sshd') do
  it { should be_enabled }
end

describe port(22) do
  it { should be_listening.with('tcp') }
end

describe linux_kernel_parameter('net.ipv4.conf.all.rp_filter') do
  its(:value) { should eq 0 }
end

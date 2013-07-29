require 'spec_helper'

describe package('openstack-swift-proxy') do
  it { should be_installed }
end

describe service('openstack-swift-proxy') do
  it { should be_enabled }
  it { should be_running }
end

describe command('swift -A http://127.0.0.1:8080/auth/v1.0 -U test:tester -K testing stat') do
  it { should return_stdout /AUTH_test/ }
  it { should return_exit_status 0 }
end

describe command('cd /etc && swift -A http://127.0.0.1:8080/auth/v1.0 -U test:tester -K testing upload testbox fstab') do
  it { should return_stdout /fstab/ }
  it { should return_exit_status 0 }
end

describe command('cd /tmp && swift -A http://127.0.0.1:8080/auth/v1.0 -U test:tester -K testing list testbox') do
  it { should return_stdout /fstab/ }
  it { should return_exit_status 0 }
end

describe command('cd /tmp && swift -A http://127.0.0.1:8080/auth/v1.0 -U test:tester -K testing download testbox fstab -o downloaded-fstab && cmp /etc/fstab downloaded-fstab') do
  it { should return_exit_status 0 }
end
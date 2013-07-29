require 'spec_helper'

describe package('openstack-swift') do
  it { should be_installed }
end

describe file('/etc/swift') do
  it { should be_directory }
end

describe file('/etc/swift/swift.conf') do
  it { should be_file }
end

describe file('/var/lib/swift') do
  it { should be_directory }
  it { should be_owned_by 'swift' }
end

describe file('/var/run/swift') do
  it { should be_directory }
  it { should be_owned_by 'swift' }
end

describe file('/var/cache/swift') do
  it { should be_directory }
  it { should be_owned_by 'swift' }
end

describe file('/home/swift') do
  it { should be_directory }
  it { should be_owned_by 'swift' }
end
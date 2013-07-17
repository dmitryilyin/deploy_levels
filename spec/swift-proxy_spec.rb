require 'spec_helper'

describe package('openstack-swift-proxy') do
  it { should be_installed }
end

describe service('openstack-swift-proxy') do
  it { should be_enabled }
  it { should be_running }
end
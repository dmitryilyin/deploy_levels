require 'spec_helper'

describe yumrepo('openstack-epel-fuel-grizzly') do
  it { should exist }
  it { should be_enabled }
end

describe yumrepo('openstack-koji-fuel-grizzly') do
  it { should exist }
  it { should be_enabled }
end

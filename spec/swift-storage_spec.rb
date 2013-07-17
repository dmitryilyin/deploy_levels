require 'spec_helper'

rings = [ 'container', 'object', 'account' ]

rings.each do |ring|
  describe package("openstack-swift-#{ring}") do
    it { should be_installed }
  end
end

rings.each do |ring|
  describe service("openstack-swift-#{ring}") do
    it { should be_enabled }
    it { should be_running }
  end
end
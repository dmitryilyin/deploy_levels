require 'spec_helper'

rings = [ 'container', 'object', 'account' ]

rings.each do |ring|
  describe file("/etc/swift/#{ring}.builder") do
    it { should be_file }
  end
end

rings.each do |ring|
  describe file("/etc/swift/#{ring}.ring.gz") do
    it { should be_file }
  end
end

describe package('rsync') do
  it { should be_installed }
end
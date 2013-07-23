require 'spec_helper'

$ntp_package = case attr[:osfamily]
  when 'Debian' then 'ntp'
  when 'RedHat' then 'ntp'
  else 'ntp'
end

describe package($ntp_package) do
  it { should be_installed }
end

MODULES_PATH='/etc/puppet/modules'
MANIFESTS_PATH='/etc/puppet/manifests'
PUPPET_OPTIONS='--verbose --detailed-exitcodes'

def puppet(manifest_file)
  fail "No such manifest '#{manifest_file}'!" unless File.exist? manifest_file
  sh "puppet apply --modulepath='#{MODULES_PATH}' #{PUPPET_OPTIONS} '#{MANIFESTS_PATH}/#{manifest_file}'" do |ok, res|
    fail "Apply of manifest '#{manifest_file}' failed with exit code #{res.exitstatus}!" unless [0,2].include? res.exitstatus
  end
end

def rspec(rspec_file)
  if File.exists? rspec_file
    sh "rspec -f doc --color '#{rspec_file}'" do |ok, res|
      fail "Test #{rspec_file} failed with exit code #{res.exitstatus}!" unless ok
    end
  else
    puts "Spec file '#{rspec_file}' doesn't exist! Skipping test phase."
  end
end

def component(component_name)
  namespace component_name do
    task :run => [ :apply, :test ] do
      puts "#{component_name} run ends"
    end
    task :apply do
      puppet "#{component_name}.pp"
      puts "#{component_name} have been applied!"
      sleep(3)
    end
    task :test do
      rspec "spec/#{component_name}_spec.rb"
      puts "#{component_name} have been tested!"
      sleep(3)
    end
  end
  desc "#{component_name} component"
  task component_name do
  	Rake::Task["#{component_name}:apply"].invoke
  	Rake::Task["#{component_name}:test"].invoke
  end
end

component('network')
component('basic')
component('swift-install')
component('swift-loopback')
component('swift-proxy')
component('swift-ring-create')
component('swift-ring-rebalance')
component('swift-ring-sync')
component('swift-storage')

namespace :deploy do
  desc "Deploy storage node"
  task :storage => ['network', 'basic', 'swift-loopback', 'swift-storage'] do
    puts "Storage deployed!"
  end
  desc "Deploy proxy node"
  task :proxy => ['network', 'basic', 'swift-ring-create', 'swift-proxy'] do
    puts "Proxy deployed!"
  end
  desc "Deploy all in one node"
  task :saio => ['network', 'basic', 'swift-ring-create', 'swift-storage', 'swift-proxy'] do
    puts "SAIO deployed!"
  end
end

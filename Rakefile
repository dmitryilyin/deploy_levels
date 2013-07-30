import 'components.rake'


def deploy(name, stages)
  desc "Deploy #{name}"
  task "deploy/#{name}" do
    if stages.respond_to?(:each)
  	  stages.each do |stage|
  	    Rake::Task["#{stage}:apply"].invoke
  	    Rake::Task["#{stage}:test"].invoke
  	  end
    end
  end
end

task :default do
  system("rake -sT")
end

################################

sanity_stages = [
  'common/supported',
  'common/role',
]

network_stages = [
  'common/network',
#  'common/firewall',
]
  
common_stages = sanity_stages + [
  'common/repos',
  'common/basic',
  'common/profile',
  'common/trace',
]

controller_stages = common_stages + network_stages + [
  'controller/controller',
  'controller/auth_file',
  'controller/cirros',
  'controller/rsyslog',
  'controller/tinyproxy',
  'controller/floating',
]

compute_stages = common_stages + [
  'compute/compute',
  'compute/rsyslog',
]

################################

deploy :common, common_stages
deploy :controller, controller_stages

import 'all_components.rake'

task :default do
  system("rake -sT")
end

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


deploy :common, [
  'common/supported',
  'common/role',
  #'common/network',
  #'common/firewall',
  'common/repos',
  'common/basic',
]

deploy :controller, [
  'common/supported',
  'common/role',
  #'common/network',
  #'common/firewall',
  'common/repos',
  'common/basic',
  'controller/controller',
  'controller/auth_file',
  'controller/cirros',
  'controller/rsyslog',
  'controller/tinyproxy',
  'controller/floating',
]

import 'all_components.rake'

task :default do
  system("rake -sT")  # s for silent
end

namespace :deploy do
  desc "Deploy Controller"
  task :controller do
    stages = [
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
    stages.each do |stage|
      Rake::Task["#{stage}:apply"].invoke
      Rake::Task["#{stage}:test"].invoke
    end
  end
end

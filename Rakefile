require 'rspec/core/rake_task'

desc "Run specs"
RSpec::Core::RakeTask.new :specs do |t|
  t.pattern = './spec/**/*_spec.rb'
end

namespace :server do

  desc 'Start the app'
  task :start do
    system "rm test-server-*.log"
    system "bundle exec puma --control-url tcp://127.0.0.1:9293 --control-token foo config.ru --redirect-stdout test-server-stdout.log --redirect-stderr test-server-stderr.log"
  end

  desc 'Restart the app'
  task :restart do
    system "bundle exec pumactl -C 'tcp://127.0.0.1:9293' --control-token foo restart"
  end
  
  desc 'Stop the app'
  task :stop do
    system "bundle exec pumactl -C 'tcp://127.0.0.1:9293' --control-token foo stop"
  end
  
end

task :default => ['specs']

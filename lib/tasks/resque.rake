require 'resque/tasks'

namespace :resque do
  task :setup => :environment do
    ENV['QUEUE'] ||= '*'
    Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }
  end

  desc "Check if there are busy workers"
  task :check_workers do
    if Resque.workers.any?(&:working?)
      puts <<-EOM
        There are resque workers that are
        currently processing jobs. Stop the
        workers by running

            sudo monit -g resque_workers stop

        wait until they are really stopped, i.e.

            ps aux | grep resque

        shows no resque processes and then
        retry the deploy. The stopped workers
        will be started automatically.
      EOM
      exit(255)
    else
      puts "There are no busy workers"
      exit(0)
    end
  end
end

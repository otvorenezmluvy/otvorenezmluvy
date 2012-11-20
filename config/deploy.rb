require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'new_relic/recipes'
require 'resque'

require "rvm/capistrano"                  # Load RVM's capistrano plugin.

set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

set :application, "crowdcloud"
set :repository,  "yadayadayada"

set :scm, :git
set :use_sudo, false
ssh_options[:forward_agent] = true

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Symlink shared"
  task :symlink_shared do
    run "ln -nfs #{shared_path} #{release_path}/shared"
  end

  desc "Symlink configuration"
  task :symlink_configuration do
    run "ln -nfs #{shared_path}/production.rb #{release_path}/config/environments/production.rb"
  end

  desc "Symlink assets-documents"
  task :symlink_assets do
    run "rm -r #{release_path}/public/documents"
    run "ln -nfs #{shared_path}/documents #{release_path}/public/documents"
    run "ln -nfs #{shared_path}/data #{release_path}/public/data"
  end

  desc "Check that no resque workers are working"
  task :check_resque do
    # This aborts the deploy if the rake task returns anything other than 0
    run "cd #{current_path}; RAILS_ENV=#{rails_env} rake resque:check_workers"
  end

  desc "Restart resque workers"
  task :restart_resque do
    run "touch #{release_path}/tmp/resque-restart.txt"
  end

  after 'deploy:update_code', 'deploy:symlink_shared', 'deploy:symlink_configuration', 'deploy:symlink_assets'
  after 'deploy', 'deploy:cleanup'
  after 'deploy:update_code' do
    run "cd #{release_path}; RAILS_ENV=production rake assets:precompile"
  end
  after "deploy:update", "newrelic:notice_deployment"


  before 'deploy', 'deploy:check_resque'
  after  'deploy', 'deploy:restart_resque'
end

require 'capistrano/ext/multistage'
require 'bundler/capistrano'

$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_type, :user
set :rvm_ruby_string, 'ree@crowdcloud'        # Or whatever env you want it to run in.


set :application, "crowdcloud"
set :repository,  "yadayadayada"

set :scm, :git
set :use_sudo, false
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

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
   end



after 'deploy:update_code', 'deploy:symlink_shared', 'deploy:symlink_configuration', 'deploy:symlink_assets'
after 'deploy', 'deploy:cleanup'
after 'deploy:update_code' do
  run "cd #{release_path}; RAILS_ENV=production rake assets:precompile"
end


end

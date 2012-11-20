set :deploy_to, "/home/contract/deploy/#{application}/"
set :rails_env, "production"
set :branch, "master"
set :user, "contract"
server "otvorenezmluvy.sk", :app, :web, :db, :primary => true

set :rvm_ruby_string, '1.9.3@crowdcloud'        # Or whatever env you want it to run in.

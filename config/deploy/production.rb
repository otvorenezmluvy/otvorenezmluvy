set :deploy_to, "/home/contract/deploy/#{application}/"
set :rails_env, "production"
set :branch, "master"
set :user, "contract"
server "46.231.96.100", :app, :web, :db, :primary => true


set :deploy_to, "/home/contract/deploy/#{application}/"
set :rails_env, "production"
set :branch, "master"
set :user, "contract"
server "195.210.29.171", :app, :web, :db, :primary => true


every 1.day, :at => '1:25am' do
  command "cd #{path} && RAILS_ENV=production /home/contract/.rvm/bin/cron_rake crowdcloud:crz:download --silent"
  command "cd #{path} && RAILS_ENV=production /home/contract/.rvm/bin/cron_rake crowdcloud:egovsk:download --silent"
end

every 1.day, :at => '2:00pm' do
  command "cd #{path} && RAILS_ENV=production /home/contract/.rvm/bin/cron_rake crowdcloud:notifications:failed_jobs --silent"
end

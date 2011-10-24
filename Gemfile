source 'http://rubygems.org'

gem 'rails', '3.1.0'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem 'foreigner'

# Asset template engines
gem 'json'
gem 'sass-rails'
gem 'coffee-script'
gem 'uglifier'
gem 'execjs'
gem 'therubyracer'
gem 'sprockets'

gem 'jquery-rails'
gem 'recaptcha', :require => 'recaptcha/rails'

gem 'curb'
gem 'kaminari'

gem 'settingslogic'

gem 'resque', "1.17.1"
gem 'SystemTimer'

gem 'devise', ">= 1.4.4"
gem 'cancan'

gem 'nokogiri'
gem 'docsplit', :git => 'http://github.com/minio-sk/docsplit.git', :branch => 'all'
gem 'gm'

gem 'redcarpet'
gem 'fastercsv'

#gem 'rpm_contrib'    #removed due to conflict with resque
gem 'newrelic_rpm'
gem 'hoptoad_notifier'
gem 'whenever'

# Deploy with Capistrano
gem 'capistrano'
gem 'capistrano-ext'

gem 'date-performance', :require => 'date/performance'

group :development, :test do
  gem 'mongrel', "1.2.0.pre2"
  gem 'silent-postgres' # get rid of those noisy queries in log
  gem 'rspec-rails'
  gem 'ci_reporter'
  gem 'foreigner'
  gem 'ruby-debug'
  gem 'ruby-prof'
end

group :test do
  gem "spork"
  gem "factory_girl_rails", "~> 1.1"
end

group :test, :cucumber do
  gem "launchy"
  gem "cucumber", "= 1.0.0"
  gem "cucumber-rails"
  gem "capybara"
  gem "database_cleaner"
  gem "fakeweb"
  gem "email_spec"
end

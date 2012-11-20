source 'http://rubygems.org'

gem 'rails', '3.2.8'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem 'memcache-client'
gem 'foreigner'

gem 'oj'
gem 'multi_json'

# Asset template engines
gem 'sass-rails'
gem 'coffee-script'
gem 'uglifier'
gem 'execjs'
gem 'therubyracer'
gem 'sprockets'

gem 'bootstrap-sass'
gem 'bootstrap-kaminari-views'

gem 'jquery-rails'
gem 'recaptcha', :require => 'recaptcha/rails'

gem 'curb'
gem 'kaminari'

gem 'settingslogic'

gem 'resque', '1.17.1'
# gem 'SystemTimer'

gem 'devise', '>= 1.4.4'
gem 'cancan'

gem 'nokogiri'
gem 'docsplit', :git => 'http://github.com/minio-sk/docsplit.git', :branch => 'all'
# gem 'gm' WHY?

gem 'redcarpet', require: 'redcarpet/compat'
gem 'fastercsv'

gem 'newrelic_rpm'
gem 'airbrake'
gem 'whenever'

gem 'garelic', git: 'git://github.com/jsuchal/garelic.git'

# gem 'date-performance', :require => 'date/performance'

group :development, :test do
  gem 'rvm-capistrano'
  gem 'thin'
  gem 'rspec-rails'
  gem 'foreigner'
  gem 'ruby-prof', '=0.10.8'
  gem 'quiet_assets'
end

group :test do
  gem 'factory_girl_rails', '~> 1.1'
end

group :test, :cucumber do
  gem 'database_cleaner'
  gem 'fakeweb'
  gem 'email_spec'
end

group :production do
  gem 'passenger_monit'
end

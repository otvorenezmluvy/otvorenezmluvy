#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require 'rubygems'

begin
  require 'ci/reporter/rake/rspec'
rescue LoadError
  # is optional
end

require File.expand_path('../config/application', __FILE__)

Crowdcloud::Application.load_tasks

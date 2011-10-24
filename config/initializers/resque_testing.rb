## short circuit async jobs for testing
#if Rails.env.test?
#  module Resque
#    def self.enqueue(task, *args)
#      task.perform(*args)
#    end
#  end
#end
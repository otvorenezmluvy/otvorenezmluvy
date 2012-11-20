class FailedJobs
  WINDOW_SIZE = 20

  def self.at(expected_failure_date)
    expected_failure_date = expected_failure_date.strftime('%d.%m.%Y')
    jobs_from_the_date = []

    start = Resque::Failure.count - WINDOW_SIZE
    start = 0 if start < 0

    begin
      jobs = Resque::Failure.all(start, WINDOW_SIZE)
      jobs.each do |job|
        failure_date = Date.parse(job["failed_at"]).strftime('%d.%m.%Y')
        if failure_date == expected_failure_date
          jobs_from_the_date << job
        end
      end
      start -= WINDOW_SIZE
    end while start >= 0 && failure_date >= expected_failure_date

    Jobs.new(jobs_from_the_date)
  end

  class Jobs
    def initialize(jobs)
      @jobs = jobs
      @queues = @jobs.group_by { |j| j["queue"] }
    end

    def count_from_queue(queue)
      jobs = @queues[queue.to_s]
      jobs ? jobs.size : 0
    end
  end
end

require 'failed_jobs'

class FailedJobsNotifier
  def self.send_notification_if_there_are_failed_jobs
    jobs = FailedJobs.at(Date.yesterday)
    number_of_failed_crz_jobs  = jobs.count_from_queue(:crz)
    number_of_failed_egov_jobs = jobs.count_from_queue(:egov)
    if number_of_failed_crz_jobs > 0 || number_of_failed_egov_jobs > 0
      FailedJobsMailer.notification(number_of_failed_crz_jobs, number_of_failed_egov_jobs)
    end
  end
end

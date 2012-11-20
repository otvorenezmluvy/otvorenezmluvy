# encoding: utf-8
class FailedJobsMailer < ActionMailer::Base
  default :from => "otvorenezmluvy@gmail.com"

  def notification(failed_crz_jobs, failed_egov_jobs)
    @failed_crz_jobs = failed_crz_jobs
    @failed_egov_jobs = failed_egov_jobs
    mail(:to => "admin@otvorenezmluvy.sk", :subject => "[OtvoreneZmluvy] Padnuté joby")
  end
end

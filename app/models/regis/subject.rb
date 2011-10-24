class Regis::Subject < ActiveRecord::Base
  self.table_name_prefix = 'regis_'
  @queue = :regis

  def self.url(regis_id)
    "http://www.statistics.sk/pls/wregis/detail?wxidorg=#{regis_id}"
  end

  def url
    Regis::Subject.url(regis_id)
  end

  def self.schedule_scraping(maximum_gap = 20)
    last_subject_id = Regis::Subject.select(:regis_id).order('regis_id desc').first.try(:regis_id)
    current_start = last_subject_id.nil? ? 1 : last_subject_id + 1
    for id in current_start..current_start+maximum_gap
      Resque.enqueue(Regis::Jobs::DownloadSubject, id)
    end
  end
end
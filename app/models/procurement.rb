class Procurement < ActiveRecord::Base
  def self.download_procurements
        Resque.enqueue(Procurements::Jobs::ImportProcurements, Procurement.order("published_on desc").first.try(:published_on))
  end
end
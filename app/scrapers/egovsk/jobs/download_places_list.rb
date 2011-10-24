module Egovsk
  module Jobs
    class DownloadPlacesList
      extend Datafine::Jobs::Download
      @queue = :egovsk

      def self.perform
        json = download("http://zmluvy.egov.sk/egov/jsonExport")
        list = ActiveSupport::JSON.decode(json)

        list.each do |place|
          last_update = Egovsk::DocumentDetail.where(:customer_id => place['id']).order("published_on desc").first.try(:published_on)
          Resque.enqueue(Egovsk::Jobs::DownloadJSON, place['id'],place['nazov'], place['zriadovatel'], 0, last_update)
        end
      end
    end
  end
end
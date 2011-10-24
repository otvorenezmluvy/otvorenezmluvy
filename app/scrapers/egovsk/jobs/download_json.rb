module Egovsk
  module Jobs
    class DownloadJSON
      extend Datafine::Jobs::Download
      @queue = :egovsk

      def self.perform(customer_id, customer_name, customer_founder, offset, last_update)
        offset_query_part = offset.to_i == 0 ? "" :"/offset:#{offset}"
        since_query_part = last_update.nil? ? "" :"/since:#{last_update.as_json.split("T").first}"
        json = download("http://zmluvy.egov.sk/egov/jsonExport/place:#{customer_id}#{offset_query_part}#{since_query_part}")
        arr = ActiveSupport::JSON.decode(json)
        if (arr.size == 500)
          Resque.enqueue(Egovsk::Jobs::DownloadJSON, customer_id, customer_name, customer_founder, (offset.to_i+500), last_update)
        end

        puts "Going to enqueue #{arr.size} documents of #{customer_id}-#{customer_name}"

        arr.each do |record|
          Resque.enqueue(Egovsk::Jobs::ParseDocument, record, customer_name, customer_founder)
        end
      end
    end
  end
end
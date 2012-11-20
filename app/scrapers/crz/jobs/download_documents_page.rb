module Crz
  module Jobs
    class DownloadDocumentsPage
      extend Datafine::Jobs::Download
      @queue = :crz

      def self.perform(page = 0)
        Crz::Appendix
        Crz::Contract
        html = download("http://www.crz.gov.sk/index.php?ID=114394&page=#{page}")
        list = Crz::Parsers::DocumentsListParser.parse(html)
        existing = Crz::Document.find_all_by_crz_id(list.contract_ids).collect(&:crz_id)
        missing = (list.contract_ids - existing)

        Resque.enqueue(Crz::Jobs::DownloadDocumentsPage, list.next_page_number) if list.next_page_number && missing.any?

        missing.each do |contract_id|
          Resque.enqueue(Crz::Jobs::DownloadDocument, contract_id)
        end
      end
    end
  end
end

module Crz
  module Parsers
    class DocumentsListParser
      def self.parse(html)
        doc = Nokogiri::HTML(html)
        ids = doc.css(".table_list .cell2 > a").collect do |anchor|
          anchor["href"][/[0-9]+/].to_i
        end

        last_pager = doc.css(".pagelist a").last
        next_page_number = (last_pager.text == " >>") ? last_pager["href"][/page=([0-9]+)/, 1].to_i : nil

        ContractsList.new(ids, next_page_number)
      end

      private
      class ContractsList < Struct.new(:contract_ids, :next_page_number); end
    end
  end
end
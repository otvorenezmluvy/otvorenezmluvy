module Egovsk
  module Parsers
    class DetailParser
      def self.parse(html)
        doc = Nokogiri::HTML(html)
        match = doc.css("table[class=detail] a").try(:first)["href"].match(/(\d+)\/(\d+)\/(.*)/)
        AttachmentIDs.new(match[1], match[2], match[3]) unless match.nil?
      end

      private
      class AttachmentIDs < Struct.new(:egovsk_doc_id, :egovsk_doc2_id, :name); end
    end
  end
end

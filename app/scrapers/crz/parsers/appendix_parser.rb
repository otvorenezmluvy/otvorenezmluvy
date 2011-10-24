module Crz
  module Parsers
    class AppendixParser < DocumentParser
      # @return [Crz::Appendix]
      def self.parse(html)
        doc = Nokogiri::HTML(html)
        document = Crz::Appendix.new(
         :contract_crz_id => doc.css("a.back").first["href"][/[0-9]+/].to_i
        )
        load_basic_info(doc, document)
        document
      end
    end
  end
end
module Crz
  module Parsers
    class ContractParser < DocumentParser
      # @return [Crz::Contract]
      def self.parse(html)
        doc = Nokogiri::HTML(html)
        contract = Crz::Contract.new(
            :contracted_amount => doc.css(".area4 .first span").first.text[/[0-9 ]+/].gsub(' ', '').to_i,
            :total_amount => doc.css(".area4 .last span").first.text[/[0-9 ]+/].gsub(' ', '').to_i
        )

        doc.css(".area7 .cell2 a").each do |a|
          crz_id = a["href"][/ID=([0-9]+)/, 1].to_i
          contract.appendix_connections.build(:crz_id => crz_id)
        end

        load_basic_info(doc, contract)

        contract
      end
    end
  end
end
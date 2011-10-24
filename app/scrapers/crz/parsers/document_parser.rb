module Crz
  module Parsers
    class DocumentParser
      def self.parse(html)
        find_suitable_parser(html).parse(html)
      end

      protected
      def self.load_basic_info(doc, document)
        document.crz_id = doc.css(".links a[class='print']").first["href"][/[0-9]+/].to_i

        doc.css(".b_right table tr").each do |row|
          value = row.css("td").first.text
          case row.css("th").first.text
            when "Č. zmluvy:", "Číslo dodatku:" :
              document.identifier = value
            when "Rezort:" :
              document.department = value
            when "Objednávateľ:", "Obstarávateľ:" :
              document.customer = value
            when "Dodávateľ:" :
              document.supplier = value
            when "IČO:" :
              document.supplier_ico = value.gsub(' ', '').to_i
            when "Názov zmluvy:", "Názov dodatku:" :
              document.name = value.squish
            when "Poznámka:"
              document.note = value
            when "Stav:"
              document.status = value
          end
        end

        doc.css(".area1 table tr").each do |row|
          value = row.css("td").first.text
          case row.css("th").first.text
            when "Suma na zmluve:" :
              document.contracted_amount = value[/[0-9 ]+/].gsub(' ', '').to_i
            when "Dátum zverejnenia:" :
              document.published_on = parse_date(value)
            when "Dátum účinnosti:" :
              document.effective_from = parse_date(value)
            when "Dátum platnosti do:" :
              document.expires_on = parse_date(value)
          end
        end

        document.emitter = doc.css(".area6 strong").first.next_sibling.text.strip

        attachments = {}

        doc.css(".area2 li a").each do |a|
          id = a["href"][/doc=([0-9]+)/, 1].to_i
          attachments[id] ||= a.text
        end
        attachments.each_with_index do |pair, index|
          document.attachments << Crz::Attachment.new(:crz_doc_id => pair[0], :number => index + 1, :name => pair[1])
        end
      end

      private
      def self.parse_date(string)
        begin
          Date.strptime(string, "%d.%m.%Y")
        rescue ArgumentError
          nil
        end
      end

      def self.find_suitable_parser(html)
        appendix?(html) ? Crz::Parsers::AppendixParser : Crz::Parsers::ContractParser
      end

      def self.appendix?(html)
        html.include?("Návrat späť na zmluvu")
      end
    end
  end
end

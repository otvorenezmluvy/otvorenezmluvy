module Egovsk
  module Parsers
    class PlacesListParser
      def self.parse(html)
        doc = Nokogiri::HTML(html)
        doc.css(".inner>.selectbox option[value]")[1..-1].collect { |element| {:id => element['value'].to_i, :name => element.inner_text} }
      end
   end
  end
end
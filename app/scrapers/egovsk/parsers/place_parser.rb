module Egovsk
  module Parsers
    class PlaceParser
      def self.parse_url(html)
        doc = Nokogiri::HTML(html)
        doc.css("#submit-export>a").first['href']
      end
    end
  end
end
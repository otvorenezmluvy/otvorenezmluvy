module Crz
  module Parsers
    module Offline
      class DocumentsParser < DumpParser
        def self.parse_html(path)
          doc = Nokogiri::HTML(open(path), nil, 'utf-8')
          doc.css('tr').each_with_index do |row, index|
            tds = row.css('td')
            Crz::Contract.create!(:name => tds[4].text.squish,
                                  :crz_id => tds[0].text,
                                  :identifier => tds[1].text,
                                  :department => tds[10].text,
                                  :customer => tds[2].text,
                                  :supplier => tds[3].text,
                                  :supplier_ico => tds[12].text.gsub(' ', ''),
                                  :contracted_amount => tds[7].text.to_f,
                                  :total_amount => tds[8].text.to_f,
                                  :note => tds[9].text.blank? ? nil : tds[9].text.squish,
                                  :published_on => parse_date(tds[11].text),
                                  :effective_from => parse_date(tds[5].text),
                                  :expires_on => parse_date(tds[6].text))
            # emitter, status
          end
        end
      end
    end
  end
end

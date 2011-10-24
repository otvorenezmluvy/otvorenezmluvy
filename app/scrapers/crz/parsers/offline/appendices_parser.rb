require 'fastercsv'

module Crz
  module Parsers
    module Offline
      class AppendicesParser < DumpParser
        def self.parse_csv(path)
          FasterCSV.foreach(path, :quote_char => '"', :col_sep => ';', :row_sep => :auto, :headers => true) do |row|
            begin
              Crz::Appendix.create!(:crz_id => row[0],
                                    :contract_crz_id => row[1],
                                    :identifier => row[2],
                                    :customer => row[3],
                                    :supplier => row[4],
                                    :name => row[5],
                                    :effective_from => parse_date(row[6]),
                                    :expires_on => parse_date(row[7]),
                                    :contracted_amount => row[8].to_f,
                                    :note => row[9].blank? ? nil : row[9].squish,
                                    :published_on => parse_date(row[10]),
                                    :total_amount => row[11].to_f)
            rescue FasterCSV::MalformedCSVError
              puts "Invalid row: #{row.inspect}"
            end
          end
        end
      end
    end
  end
end

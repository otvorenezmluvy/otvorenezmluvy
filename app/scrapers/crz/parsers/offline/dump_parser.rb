module Crz
  module Parsers
    module Offline
      class DumpParser
        def self.parse_date(string)
          begin
            Date.strptime(string, "%Y-%m-%d")
          rescue ArgumentError
            nil
          end
        end
      end
    end
  end
end

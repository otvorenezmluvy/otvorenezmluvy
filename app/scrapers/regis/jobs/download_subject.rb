module Regis
  module Jobs
    class DownloadSubject
      extend Datafine::Jobs::Download
      @queue = :regis
      def self.perform(regis_id)
        begin
          Regis::Parsers::RegisParser.parse(download(Regis::Subject.url(regis_id))).save
        rescue OpenURI::HTTPError
        end
      end
    end
  end
end
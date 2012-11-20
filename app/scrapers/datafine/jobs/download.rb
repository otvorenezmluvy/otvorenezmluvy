require 'open-uri'

module Datafine
  module Jobs
    module Download
      protected
      def download(url, filename = nil)
        # TODO find a better way to download to save memory
        html = open(url, 'r:utf-8').read
        if filename
          FileUtils.mkdir_p(File.dirname(filename))
          f = File.open(filename, "wb")
          begin
            f.write html
          ensure
            f.close
          end
        end
        html
      end


      def download_with_cookies(url, name)
        FileUtils.mkdir_p(File.dirname(name))
        `wget --cookies=on --keep-session-cookies --load-cookies=#{Rails.root}/data/#{Rails.env}/cookie.txt --save-cookies=#{Rails.root}/data/#{Rails.env}/cookie.txt #{url} -O #{name}`
      end

    end
  end
end

module Crz
  module Jobs
    class DownloadDocument
      extend Datafine::Jobs::Download
      @queue = :crz

      def self.perform(crz_id)
        # TODO find existing
        html = download("http://www.crz.gov.sk/index.php?ID=#{crz_id}&l=sk")
        document = Crz::Parsers::DocumentParser.parse(html)

        document.attachments.each do |attachment|
          download_attachment(attachment)
          extract_text(attachment)
          extract_images(attachment)
          attachment.delete_original
        end

        document.appendix_connections.each do |appendix|
          Resque.enqueue(Crz::Jobs::DownloadDocument, appendix.crz_id) unless Crz::Contract.find_all_by_crz_id(appendix.crz_id).any?
        end if document.respond_to? :appendix_connections

        Configuration.documents_repository.save!(document)
      end

      private
      def self.download_attachment(attachment)
        download(attachment.crz_original_url, attachment.path_to_hardcopy(:original))
        download(attachment.crz_text_url, attachment.path_to_hardcopy(:text))
      end

      def self.extract_text(attachment)
        source_pdf = attachment.path_to_hardcopy(:text)
        target_path = attachment.path_to_pages
        Docsplit.extract_text(source_pdf, :output => target_path, :ocr => false, :clean => false, :pages => 'all')
        Dir["#{target_path}/*.txt"].sort.each do |entry|
          page_number = entry[/_([0-9]+)\.txt/, 1].try(:to_i)
          if page_number
            text = File.read(entry)
            attachment.pages.build(:text => text, :number => page_number)
          end
        end
      end

      def self.extract_images(attachment)
        source_pdf = attachment.path_to_hardcopy(:original)
        target_path = File.join(attachment.path_to_pages_images, '1000x')
        Docsplit.extract_images(source_pdf, :size => ['1000x'], :rolling => true, :output => target_path, :format => :gif)
      end
    end
  end
end

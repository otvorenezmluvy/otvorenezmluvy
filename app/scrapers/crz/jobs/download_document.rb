require 'base_name'

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
          attachment.delete_text
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
        pdfs = [attachment.path_to_hardcopy(:text), attachment.path_to_hardcopy(:original)]
        target_path = attachment.path_to_pages
        try_extraction(pdfs) do |source_pdf|
          Docsplit.extract_text(source_pdf, :output => target_path, :clean => true, :pages => 'all', :language => 'ces')
          Dir["#{target_path}/*.txt"].sort.each do |entry|
            page_number = entry[/_([0-9]+)\.txt/, 1].try(:to_i)
            if page_number
              text = File.read(entry)
              attachment.pages.build(:text => text, :number => page_number)
            end
          end
          attachment.base_text_name = BaseName.extract(source_pdf)
        end
      end

      def self.extract_images(attachment)
        pdfs = [attachment.path_to_hardcopy(:original), attachment.path_to_hardcopy(:text)]
        target_path = File.join(attachment.path_to_pages_images, '1000x')
        try_extraction(pdfs) do |source_pdf|
          Docsplit.extract_images(source_pdf, :size => ['1000x'], :rolling => true, :output => target_path, :format => :gif)
          attachment.base_image_name = BaseName.extract(source_pdf)
        end
      end

      private
      def self.try_extraction(pdfs, &block)
        begin
          source_pdf = pdfs.shift
          block.call(source_pdf)
          return
        rescue Docsplit::ExtractionFailed
          retry unless pdfs.empty?
        end
      end
    end
  end
end

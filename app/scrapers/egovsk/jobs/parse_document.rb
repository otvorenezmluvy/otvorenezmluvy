module Egovsk
  module Jobs
    class ParseDocument
      extend Datafine::Jobs::Download
      @queue = :egovsk_documents

      def self.perform(record, customer_name, customer_founder)
        existing_doc = Egovsk::Document.find_all_by_egovsk_id(record["id_zmluvy"].to_i).first
        doc = Egovsk::Parsers::JSONParser.parse(record, existing_doc)

        doc.customer = customer_name
        doc.founder = customer_founder

        begin
        doc.attachments.each do |attachment|
          download_attachment(attachment)
          extract_text(attachment)
          extract_images(attachment)
        end
        rescue StandardError => error
          Rails.logger.error "#{error} while processing #{customer_name.to_s}:#{record["id_zmluvy"].to_s}"
        end

        Configuration.documents_repository.save!(doc)
        doc.attachments.each { |a| a.save! }
      end

      private
      def self.download_attachment(attachment)
        download(attachment.egovsk_original_url, attachment.path_to_hardcopy(:as_is))
      end

      def self.extract_text(attachment)
        source_document = attachment.path_to_hardcopy(:as_is)
        target_path = attachment.path_to_pages
        Docsplit.extract_text(source_document, :output => target_path, :clean => true, :pages => 'all', :language => 'ces')
        Dir["#{target_path}/*.txt"].sort.each do |entry|
          page_number = entry[/_([0-9]+)\.txt/, 1].try(:to_i)
          if page_number
            text = File.read(entry)
            attachment.pages.build(:text => text, :number => page_number)
          end
        end
      end

      def self.extract_images(attachment)
        source_document = attachment.path_to_hardcopy(:as_is)
        target_path = File.join(attachment.path_to_pages_images, '1000x')
        Docsplit.extract_images(source_document, :size => ['1000x'], :rolling => true, :output => target_path, :format => :gif)
      end
    end
  end
end

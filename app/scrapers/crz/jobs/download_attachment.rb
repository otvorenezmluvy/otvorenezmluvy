# encoding: utf-8
module Crz
  module Jobs
    class DownloadAttachment
      extend Datafine::Jobs::Download
      @queue = :crz_attachments

      def self.perform(attachment_id)
        attachment = Crz::Attachment.find(attachment_id)
        download_attachment(attachment)
        extract_images(attachment)
        extract_text(attachment)
        Configuration.documents_repository.save(attachment.document)
      end

      private

      def self.download_attachment(attachment)
        download(attachment.crz_original_url, attachment.path_to_hardcopy(:original))
        download(attachment.crz_text_url, attachment.path_to_hardcopy(:text))
      end

      def self.extract_text(attachment)
        source_pdf = attachment.path_to_hardcopy(:text)
        target_path = attachment.path_to_pages

        if File.read(source_pdf).include?('Chyba pri preberaní súboru')
          Resque.enqueue(Crz::Jobs::OcrAttachment, attachment.id)
        else
          Docsplit.extract_text(source_pdf, :output => target_path, :clean => true, :pages => 'all', :language => 'ces')

          Dir["#{target_path}/*.txt"].sort.each do |entry|
            page_number = entry[/_([0-9]+)\.txt/, 1].try(:to_i)
            if page_number
              text = File.read(entry)
              attachment.pages.build(:text => text, :number => page_number)
            end
          end
          attachment.save!
          attachment.delete_original
          attachment.delete_text
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

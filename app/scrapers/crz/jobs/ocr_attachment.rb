module Crz
  module Jobs
    class OcrAttachment
      extend Datafine::Jobs::Download
      @queue = :crz_ocr

      def self.perform(attachment_id)
        attachment = Crz::Attachment.find(attachment_id)
        source_pdf = attachment.path_to_hardcopy(:original)
        target_path = attachment.path_to_pages

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
  end
end

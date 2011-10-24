module Crz
  module Jobs
    module Bulk
      class ScheduleAttachmentDownload
        @queue = :crz_attachments

        def self.perform
          Crz::Attachment.find_each do |attachment|
            Resque.enqueue(Crz::Jobs::DownloadAttachment, attachment.id)
          end
        end
      end
    end
  end
end

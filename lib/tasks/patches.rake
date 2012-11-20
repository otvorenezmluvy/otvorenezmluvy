namespace :patches do
  desc "Corrects paths to document images"
  task :correct_paths => :environment do
    Crz::Attachment.find_each do |attachment|
      if attachment.pages.any?
        page_path = attachment.pages.first.path_to_hardcopy(:image, :size => '1000x')
        unless File.exist?(page_path)
          puts "Fixing page path for attachment id #{attachment.id}"
          if env['I_REALLY_MEAN_IT']
            attachment.base_image_name = attachment.base_image_name + "-text"
            attachment.save!
          end
        end
      end
    end
  end
end

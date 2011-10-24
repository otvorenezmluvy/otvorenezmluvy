namespace :crowdcloud do
  desc "Parse CRZ HTML dump"
  task "crz:bulk" => :environment do
    #Crz::Contract.delete_all
    #Crz::Appendix.delete_all
    #ActiveRecord::Base.connection.execute "delete from pages where id in (select p.id from pages p join attachments a on p.attachment_id = a.id and a.type = 'Crz::Attachment')"
    #Crz::AttachmentDetail.delete_all
    #Crz::Attachment.delete_all
    #Crz::Parsers::Offline::DocumentsParser.parse_html("#{Rails.root}/tmp/dumps/crz.html")
    #Crz::Parsers::Offline::AppendicesParser.parse_csv("#{Rails.root}/tmp/dumps/dodatky.csv")
    #Crz::Parsers::Offline::AttachmentsParser.parse_csv("#{Rails.root}/tmp/dumps/prilohy.csv")
    Resque.enqueue(Crz::Jobs::Bulk::ScheduleAttachmentDownload)
  end

  desc "Download missing documents from crz.gov.sk"
  task "crz:download" => :environment do
    Resque.enqueue(Crz::Jobs::DownloadDocumentsPage)
  end
  desc "Download missing documents from zmluvy.egov.sk"
  task "egovsk:download" => :environment do
    Resque.enqueue(Egovsk::Jobs::DownloadPlacesList)
  end

  desc "Download missing subjects from regis"
  task "regis:download", [:max] => :environment do |t, args|
    puts args.inspect
    max = args[:max].to_i || 20
    Regis::Subject.schedule_scraping(max)
  end

  desc "Download missing procurements via TIS API"
  task "procurements:download" => :environment do
    Procurement.download_procurements
  end

  desc "Delete all originals of CRZ attachments"
  task "crz:delete_originals" => :environment do
    Crz::Document.all.each do |document|
      document.attachments.each do |attachment|
        attachment.delete_original
      end
    end
  end

  desc "Requeue failed all jobs"
  task "requeue" => :environment do
    i=0
    while job = Resque::Failure.all(i)
      if job['queue'] == "crz_attachments"
        Resque::Failure.requeue(i)
      end
      i+=1
    end
    Resque::Failure.clear
  end


  desc "Reindex"
  task "index:rebuild" => :environment do
    Configuration.documents_repository.recreate
    Configuration.documents_repository.reindex_all
    Configuration.pages_repository.reindex_all
  end

  desc "Rebuild heuristics"
  task "heuristics:rebuild" => :environment do
    Heuristic.all.each do |heuristic|
      Resque.enqueue(Heuristic::Jobs::AddHeuristicToMatchingDocuments, heuristic.id, heuristic.create_search(::Configuration.factic).build_query)
    end
  end
end

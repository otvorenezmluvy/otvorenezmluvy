require 'fastercsv'

module Crz
  module Parsers
    module Offline
      class AttachmentsParser < DumpParser
        def self.parse_csv(path)
          FasterCSV.foreach(path, :quote_char => '"', :col_sep => ';', :row_sep => :auto, :headers => true) do |row|

            parent_document = Crz::Contract.find_all_by_crz_id(row['nadrad']).first
            parent_document ||= Crz::Appendix.find_all_by_crz_id(row['nadrad']).first

            unless parent_document
              puts "Parent document #{row['nadrad']} not found, skipping attachment"
              next
            end

            if separate_scan_and_text_attachment?(row)
              linked_attachment = find_linked_attachment(parent_document, row)
              if linked_attachment
                if type(row) == :scan
                  linked_attachment.crz_doc_id  = row['ID']
                  linked_attachment.name = row['nazov']
                end
                linked_attachment.crz_text_id = row['ID'] if type(row) == :text
                linked_attachment.crz_attachment_detail.save!
                linked_attachment.save!
                next
              end
            end

            attributes = {
              :name => row['nazov'],
              :note => row['art_popis'],
              :document => parent_document,
              :number => next_number_for(parent_document)
            }

            if separate_scan_and_text_attachment?(row)
              attributes[:crz_doc_id]  = row['ID'] if type(row) == :scan
              attributes[:crz_text_id] = row['ID'] if type(row) == :text
            else
              attributes[:crz_doc_id]  = row['ID']
            end

            Crz::Attachment.create!(attributes)
          end
        end

        def self.separate_scan_and_text_attachment?(csv)
          csv['art_velkost1'] == '0'
        end

        def self.type(csv)
          if csv['nazov'] =~ /text/ || csv['art_popis'] =~ /text/
            :text
          else
            :scan
          end
        end

        def self.find_linked_attachment(parent_document, csv)
          if type(csv) == :text
            parent_document.attachments.detect { |a| a.note =~ /podp/ || a.name =~ /podp/ }
          else
            parent_document.attachments.detect { |a| a.note =~ /text/ || a.name =~ /text/ }
          end
        end

        def self.next_number_for(document)
          current = document.attachments.maximum(:number) || 0
          current + 1
        end
      end
    end
  end
end

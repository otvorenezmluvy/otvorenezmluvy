module Egovsk
  module Parsers
    class JSONParser
      def self.parse(record, doc = nil)
        is_appendix = record["dodatok"] != "0" || record["vypoved"] != "0"
        if doc
          doc.attachments.destroy_all
        else
          document = is_appendix ? Egovsk::Appendix : Egovsk::Contract
          doc = document.new
        end
        doc.customer_id = record["id_institucie"].to_i
        doc.name = record["predmet"]
        doc.egovsk_id = record["id_zmluvy"].to_i
        doc.total_amount = record["cena"].to_i unless record["cena"].blank?
        doc.supplier = record["partner_name"]
        doc.supplier_ico = record["partner_ico"].to_i
        doc.note = record["poznamka"]
        doc.signed_on = Date.parse(record["datum_podpisu"]) unless record["datum_podpisu"].nil?
        doc.published_on = Date.parse(record["datum_zverejnenia"]) unless record["datum_zverejnenia"].nil?
        doc.effective_from = Date.parse(record["datum_ucinnosti"]) unless record["datum_ucinnosti"].nil?
        doc.valid_from = Date.parse(record["platnost_od"]) unless record["platnost_od"].nil?
        doc.expires_on = Date.parse(record["platnost_do"]) unless record["platnost_do"].nil?
        doc.contract_number = record["cislo_zmluvy"]
        doc.contract_type = record["druh_zmluvy"]
        doc.periodicity = record["periodicita"]
        if (is_appendix)
          doc.root_contract_number = record["id_povodnej_zmluvy"]
        end
        if (record["subory"])
          record["subory"].each_index do |i|
            match = record["subory"][i]["url"].match(/(\d+)\/(\d+)\/(.*)/)
            doc.attachments << Egovsk::Attachment.new(:egovsk_attachment_type => record["subory"][i]["typ"], :egovsk_doc_id => match[1], :egovsk_doc2_id => match[2], :name => match[3], :number => i+1)
          end
        end
        doc
      end
    end
  end
end

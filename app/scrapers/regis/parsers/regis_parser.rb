# encoding: utf-8
module Regis
  module Parsers
    class RegisParser
      def self.parse(html)
        doc = Nokogiri::HTML(html, nil, "windows-1250")

        subject = Regis::Subject.new(
            :regis_id => doc.css("input[value=Výpis]").first["onclick"].match(/vypis_xidorg=(\d+)/)[1].to_i,
            :ico => doc.css(".tabid td:nth-child(3)")[0].content.to_i,
            :name => doc.css(".tabid td:nth-child(3)")[1].content,
            :address => doc.css(".tabid td:nth-child(3)")[5].content.gsub(/\302\240/, ''),
            :created_on => Date.parse(doc.css(".tabid td:nth-child(3)")[3].content),
            :district => doc.css(".tabid td:nth-child(3)")[6].content.strip,
            :legal_form_label => doc.css(".tablist td:nth-child(3)")[0].content,
            :sk_nace_category_label => doc.css(".tablist td:nth-child(3)")[1].content,
            :okec_category_label => doc.css(".tablist td:nth-child(3)")[2].content,
            :sector_label => doc.css(".tablist td:nth-child(3)")[3].content,
            :ownership_category_label => doc.css(".tablist td:nth-child(3)")[4].content,
            :organisation_size_category_label => doc.css(".tablist td:nth-child(3)")[5].content
        )
        legal_form = doc.css(".tablist td:nth-child(2)")[0].content
        subject.legal_form_code = legal_form.to_i unless legal_form.blank?
        sk_nace_category_code = doc.css(".tablist td:nth-child(2)")[1].content
        subject.sk_nace_category_code = sk_nace_category_code unless sk_nace_category_code.blank?
        okec_category_code = doc.css(".tablist td:nth-child(2)")[2].content
        subject.okec_category_code = okec_category_code.to_i unless okec_category_code.blank?
        sector_code = doc.css(".tablist td:nth-child(2)")[3].content
        subject.sector_code = sector_code.to_i unless sector_code.blank?
        organisation_size_category_code = doc.css(".tablist td:nth-child(2)")[5].content
        subject.organisation_size_category_code = organisation_size_category_code.to_i unless organisation_size_category_code.blank?
        ownership_category_code = doc.css(".tablist td:nth-child(2)")[4].content
        subject.ownership_category_code = ownership_category_code.to_i unless ownership_category_code.blank?
        dissolved_on = doc.css(".tabid td:nth-child(3)")[4].content
        subject.dissolved_on = Date.parse(dissolved_on) if dissolved_on.match(/\d+\.\d+\.\d+/)
        subject
      end
    end
  end
end
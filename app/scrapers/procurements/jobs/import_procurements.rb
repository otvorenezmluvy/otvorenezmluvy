module Procurements
  module Jobs
    class ImportProcurements
      extend Datafine::Jobs::Download
      @queue = :procurements

      def self.perform(last_update)
        since_query_part = last_update.nil? ? "" :"&cut=date:#{last_update.year},#{last_update.month}"

        download("http://slicer.democracyfarm.org/vestnik-preprod/facts?format=csv&#{since_query_part}", "#{Rails.root}/data/procurements" )
        download("http://vestnik-test.democracyfarm.org/dump/vvo_data.ft_vvo_contracts.csv", "#{Rails.root}/data/procurements_additional" )
        sql = <<-SQL
        TRUNCATE TABLE "ft_vvo_contracts";
        TRUNCATE TABLE "temp_procurements";
        COPY temp_procurements FROM 'filename' WITH CSV  HEADER;
        UPDATE temp_procurements SET supplier_ico = null WHERE supplier_ico = 'UNKNOWN';
        COPY ft_vvo_contracts FROM 'additional' WITH CSV  HEADER;
        INSERT INTO procurements (select * from temp_procurements);
        update procurements
        SET zakazka_eurofondy_flag = f.zakazka_eurofondy_flag,
        elektronicka_aukcia_flag = f.elektronicka_aukcia_flag,
        druh_zakazky = f.druh_zakazky,
        druh_zakazky_code = f.druh_zakazky_code,
        druh_zakazky_id = f.druh_zakazky_id,
        pocet_ponuk = f.pocet_ponuk,
        document_id = f.document_id
        FROM ft_vvo_contracts f WHERE
          procurements.source_url = f.source_url
        SQL
        sql = sql.gsub('filename',"#{Rails.root}/data/procurements")
        sql = sql.gsub('additional',"#{Rails.root}/data/procurements_additional")
        ActiveRecord::Base.connection.execute(sql)
      end
    end
  end
end

xml.instruct! :xml, :version => "1.0"

xml.rss :version => "2.0" do
 xml.channel do
   xml.title       Configuration.site_name
   xml.link        search_documents_url(:rss)
   xml.description "#{Configuration.site_name} RSS feed"

   @results.hits.each do |result|
     xml.item do
       xml.title       result.name
       xml.link        document_url(result.id)
       xml.description "#{result.supplier} pre #{result.customer} za #{result.total_amount} EUR, #{result.published_on}"
       xml.guid         document_url(result.id)
     end
   end

 end
end

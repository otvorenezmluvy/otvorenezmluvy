class PagesRepository
  def initialize(index)
    @index = index
  end

  def search(query_string, document_id_or_ids)
    ids = document_id_or_ids.is_a?(Array) ? document_id_or_ids : [document_id_or_ids]
    query = {
        :query => {
            :filtered => {
                :query => {
                    :query_string => {
                        :query => query_string,
                        :default_field => :text
                    }
                },
                :filter => {
                    :terms =>
                        {'attachment.document_id' => ids}
                }
            },

        },
        :highlight => {
            :fields => {
                :text => {:fragment_size => 100}
            }
        },
        :sort => [:number],
        :size => 10
    }
    @index.search(query)
  end

  def document_saved(document)
    document.attachments.collect(&:pages).flatten.each do |page|
      @index.index(page)
    end
  end

  def reindex_all
    @index.reindex_all(:attachment)
  end
end

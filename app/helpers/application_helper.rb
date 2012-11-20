module ApplicationHelper
  def link_to_newest_rss title
    link_to title, search_documents_path(:sort => :published_on, :format => :rss)
  end

  def link_to_most_discussed_rss title
    link_to title, search_documents_path(:sort => :comments_count, :format => :rss)
  end

  def format_count(count)
    number_with_delimiter(count, :delimiter => " ")
  end
end

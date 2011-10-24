module ApplicationHelper
  def body_class
    return (@body_class.nil?) ? "" : " class='#{@body_class}'"
  end

  def link_to_newest_rss title
    link_to title, search_documents_path(:sort => :published_on, :format => :rss)
  end

  def link_to_most_discussed_rss title
    link_to title, search_documents_path(:sort => :comments_count, :format => :rss)
  end
end

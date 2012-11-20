# encoding: utf-8
module DocumentsHelper
  def link_to_document(name, document)
    link_to name, document_path(document)
  end

  def format_unixtimestamp_to_month(timestamp)
    Time.at(timestamp / 1000).strftime("%m. %Y")
  end

  def document_discussion_path(document, options = {})
    document_path(document, options.merge(:anchor => 'diskusia'))
  end

  def document_page_anchor(page)
    "document/#{page.attachment.number}/page/#{page.number}"
  end

  def comment_anchor(comment)
    "document/#{comment.page.attachment.number}/page/#{comment.page.number}/comment/#{comment.id}"
  end

  def document_comment_anchor(document, comment)
    document_path(document, :anchor => dom_id(comment.id))
  end

  def t_page_count(count)
    t(:pages, :count => count.to_i)
  end

  def range_to_page_counts(range)
    return "menej ako #{t_page_count(range.end)}".html_safe if range.begin == -Infinity
    return "viac ako #{t_page_count(range.begin)}".html_safe if range.end == Infinity
    "#{range.begin.to_i} až #{t_page_count(range.end)}".html_safe
  end

  def range_to_points(range)
    human_numeric_range(range, :points)
  end

  def human_numeric_range(range, translator)
    return "menej ako #{t(translator, :count => range.end.to_i)}".html_safe if range.begin == -Infinity
    return "viac ako #{t(translator, :count => range.begin.to_i)}".html_safe if range.end == Infinity
    "#{range.begin.to_i} až #{t(translator, :count => range.end.to_i)}".html_safe
  end

  def range_to_datespan(range)
    from, to = range.begin, range.end
    if from.year == to.year
      if from.month == to.month
        if from == from.beginning_of_month && to == to.end_of_month
          return "#{l(from, :format => "%B %Y")}"
        end
      end

      if from == from.beginning_of_year && to == to.end_of_year
        return from.year
      end
      "#{l(from)} až #{l(range.end)}"
    else
      return "skôr ako #{to.year}" if from == Factic::RangeFacet::Converters::Date.lower_bound
      return "neskôr ako #{from.year}" if to == Factic::RangeFacet::Converters::Date.upper_bound
      "#{from.year} - #{to.year}"
    end
  end

  def humanize_duration(duration_in_days)
    years, rest = duration_in_days.divmod 365
    months, days = rest.divmod 30

    duration = []
    duration << t(:years, :count => years) if years > 0
    duration << t(:months, :count => months) if months > 0
    duration << t(:days, :count => days) if days > 0
    duration.join(' ')
  end

  def heuristics_from_hit(hit)
    result = ""
    hit.matching_heuristics.each do |heuristic|
      result << link_to(heuristic.name, search_documents_path(ActiveSupport::JSON.decode(heuristic.serialized_search_parameters).with_indifferent_access), :class => 'heuristic_label')
      result << "&nbsp;"
    end
    result
  end

  def shorten_department(department)
    department.gsub('Ministerstvo', 'Min.')
  end
end

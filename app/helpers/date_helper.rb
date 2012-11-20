# encoding: utf-8
module DateHelper
  def human_ago(days)
    return t(:days, :count => days) if days < 30
    return t(:months, :count => (days/30).to_i) if days < 365
    t(:years, :count => (days/365).to_i)
  end

  def range_to_ago(range)
    return "menej ako #{human_ago(range.end)}".html_safe if range.begin == -Infinity
    return "viac ako #{human_ago(range.begin)}".html_safe if range.end == Infinity
    "#{human_ago(range.begin)} až #{human_ago(range.end)}".html_safe
  end

  def date_to_human(date)
    date.try(:strftime, "%d.%m.%Y - %H:%M")
  end

  def format_date_or_unknown(date)
    return t('date.unknown') if date.nil?
    l(date)
  end
end

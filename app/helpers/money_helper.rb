# encoding: utf-8
module MoneyHelper
  def number_to_euro(amount)
    number_to_currency(amount, :unit => "&euro;", :delimiter => ' ', :format => "%n&nbsp;%u", :precision => 0)
  end

  def range_to_euro(range)
  return "menej ako #{number_to_euro(range.end)}".html_safe if range.begin == -Infinity
  return "viac ako #{number_to_euro(range.begin)}".html_safe if range.end == Infinity
   "#{number_to_euro(range.begin)} až #{number_to_euro(range.end)}".html_safe
  end
end

class window.DateFormat
  @format = (date) ->
    if date
      "#{date.getDate()}.#{date.getMonth()}.#{date.getYear()} #{date.getHours()}:#{date.getMinutes()}"

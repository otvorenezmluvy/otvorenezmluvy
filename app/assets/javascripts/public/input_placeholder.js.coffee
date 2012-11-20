$("input.clear")
  .focus (event) ->
    if $(this).attr("value") == $(this).attr("data-placeholder")
      $(this).attr("value", "")
  .blur (event) ->
    if $(this).attr("value") == ""
      $(this).attr("value", $(this).attr("data-placeholder"))

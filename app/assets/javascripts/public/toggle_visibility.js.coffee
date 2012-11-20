$ ->
  toggle = (elem) ->
    togglerId = $(elem).data('toggle')
    $("##{togglerId}").toggle()

  $('.toggle').click ->
    toggle(this)
    false

  $('.toggle-and-destroy').click ->
    toggle(this)
    $(this).remove()
    false

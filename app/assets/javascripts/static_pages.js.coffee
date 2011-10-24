$ ->
  $('.show-page-instructions').click ->
    $('.page-edit').show()
    $(this).remove()
    false

$ ->
  $('*[data-tab-switch]').click ->
    $('*[data-tab-switch]').removeClass('active')
    $(this).addClass('active')
    $(".tab").hide()
    $("##{$(this).data('tab-switch')}").show()
    false

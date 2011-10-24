$(document).ready ->
  $("#users").dataTable oLanguage:
    sProcessing: "Pracujem..."
    sLengthMenu: "Zobraz _MENU_ záznamov"
    sZeroRecords: "Neboli nájdené žiadne záznamy"
    sInfo: "Záznamy _START_ až _END_ z celkovo _TOTAL_"
    sInfoEmpty: "Záznamy 0 až 0 z celkovo 0"
    sInfoFiltered: "(filtrované z celkovo _MAX_ záznamov)"
    sInfoPostFix: ""
    sSearch: "Hľadaj:"
    sUrl: ""
    oPaginate:
      sFirst: "Prvá"
      sPrevious: "Predchádzajúca"
      sNext: "Ďalšia"
      sLast: "Posledná"

$(document).ready ->
  $('.ip_ban').click ->
    url = $(this).closest('a').attr('href')
    $.get url, {}, (data) ->
      message = "Týmto krokom zablokujete týchto používateľov:"
      message += "\n-----------------------------------------------------------------------------------\n" + user.name + ", " + user.email for user in data
      message += "\n-----------------------------------------------------------------------------------\nJe to v poriadku?"
      if(confirm(message))
        $.post url, (data) ->
          location.reload()
    false


$(document).ready ->
  $('.user_admin').click ->
    $(this).closest('form').submit()

$(document).ready ->
  $('.user_expert').click ->
    $(this).closest('form').submit()


#  $('.account_ban').click ->
#    url = $(this).closest('a').attr('href')
#    if(confirm("Naozaj chcete tohto používateľa zablokovať?"))
#      $.post url, (data) ->
#        location.reload()
#    false
$ ->
  $('form.dashboard input[type=checkbox]').change ->
    $(this).closest('form').submit()

$ ->
  $('form.per_page select').change ->
    $(this).closest('form').submit()
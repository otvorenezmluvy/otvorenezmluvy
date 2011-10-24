$(".choice-with-detail").live('click'
  ->
    toggle_active_choice(this)
    $(this).siblings(".question-choice-detail-text").show()
    $(this).siblings(".question-choice-detail-button").show()
    upload_response(this)
    false
  )

$(".choice").live('click'
  ->
    toggle_active_choice(this)
    $(this).siblings(".question-choice-detail-text").hide()
    $(this).siblings(".question-choice-detail-button").hide()
    upload_response(this, null)
    false
  )

$(".question-choice-detail-button").live('click'
  ->
    choice = $(this).siblings(".choice-with-detail.active")
    detail = $(this).siblings(".question-choice-detail-text").val()
    upload_response(choice, detail)
    $(this).attr('disabled', 'disabled')
    false
  )

toggle_active_choice = (element) ->
    $(element).addClass("active")
    $(sibling).removeClass("active") for sibling in $(element).siblings("a")

upload_response = (choice_element, text) ->
  data =
    question: $(choice_element).parent().attr("id")
    choice: $(choice_element).attr("id")
    detail: text
  $.post($(choice_element).siblings(".post-url").val(),data, (response) ->
      $("#progressbar").progressbar( "option", "value", response)
      $("#progress_value").text(response + "%")
    )

$(document).ready ->
  progress_value = $("#progressbar").attr("data-value")
  $("#progressbar").progressbar
    value: parseInt(progress_value)

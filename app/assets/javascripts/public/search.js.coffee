# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $('*[data-toggle-id]').click ->
    container_id = $(this).attr('data-toggle-id')
    $("#" + container_id).toggle()
    focus_id = $(this).attr('data-focus-id')
    $("#" + focus_id).focus() if focus_id

  $("input.search").click ->
    $(this).closest("form").submit() unless $("#search").attr('value') == $("#search").attr("data-placeholder");

  $("*[data-placeholder]").each ->
    $(this).attr("value", $(this).attr("data-placeholder")) if ($(this).attr("value") == "")
  $("*[data-placeholder]")
    .focus ->
      $(this).attr("value", "") if ($(this).attr("value") == $(this).attr("data-placeholder"))
    .blur ->
      $(this).attr("value", $(this).attr("data-placeholder"))  if ($(this).attr("value") == "")

  $('.nav .next').click ->
    $("select#sort").closest("form").append('<input id="sort_order" name="sort_order" type="hidden" value="desc">')
    $("select#sort").closest("form").submit()

  $('.nav .prew').click ->
    $("select#sort").closest("form").append('<input id="sort_order" name="sort_order" type="hidden" value="asc">')
    $("select#sort").closest("form").submit()

  $("li.collapsed a.title").live 'click', ->
    $(this).siblings().show()
    $(this).parent("li").removeClass("collapsed").addClass("open")
    change_status($(this).parent("li").data("name"), "open", $(this).parents("#facets").data("url"))
    false

  $("li.open a.title").live 'click', ->
    $(this).siblings().hide()
    $(this).parent("li").removeClass("open").addClass("collapsed")
    change_status($(this).parent("li").data("name"), "collapsed", $(this).parents("#facets").data("url"))
    false

  $('.search #q')
    .bind('ajaxStart', -> $(this).addClass("loading"))
    .bind('ajaxComplete', -> $(this).removeClass("loading"))

  $('.confirmable input').keypress ->
    $('input[type=submit]', $(this).parents('form')).addClass('active')

$("select#sort").live('change'
 ->
    $(this).closest("form").submit()
  )

change_status = (name, to, url) ->
  data =
    name: name
    to: to
  $.post(url, data)

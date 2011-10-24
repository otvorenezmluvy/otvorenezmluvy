class window.NavigationView extends Backbone.View
  events:
    "click ._dv_prev_page": "previousPage",
    "click ._dv_next_page": "nextPage",
    "keypress ._dv_current_page": "jumpToPageOnEnter"

  render: =>
    $('._dv_current_page').val(@editor.getCurrentPageNumber())
    $('._dv_total_pages').html(@editor.getTotalPages())

  initialize: (options) ->
    @editor = options.editor
    @editor.bind("document:change", @render, @)
    @editor.bind("document:switch", @render, @)
    @editor.bind("document:error", @render, @)
    @input = $('._dv_current_page')

  previousPage: ->
    @editor.previousPage()
    false

  nextPage: ->
    @editor.nextPage()
    false

  jumpToPageOnEnter: (e) ->
    if e.which is 13
      current_page = @input.val()
      @input.blur()
      current_page = @editor.setCurrent(page_number: current_page)

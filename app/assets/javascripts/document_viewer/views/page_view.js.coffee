class window.PageView extends Backbone.View
  tagName:   "div"
  className: "page"

  initialize: (options) ->
    @editor = options.editor
    @model.bind("change", @render, @)
    @setupStyles()
    @prepareComments()

  setupStyles: ->
    $(@el).css(width: '673px', height: '990px', position: 'relative')

  render: =>
    if @model.get("type") is "scan"
      if @model.get("hidden")
        $(@el).html("<div class='blank_page'>Načítavam..</div>")
      else
        @image = $("<img src='#{@model.get("scanUrl")}' style='border: none; margin: 0; padding: 0; position: absolute; height: 990px; width: 673px;' />") unless @image
        $(@el).empty().append(@image)
        @setupAreaSelector()
        @renderComments()
    else
      if @model.get("hidden")
        $(@el).html("<div class='blank_page'>Načítavam..</div>")
      else
        $(@el).html("#{@model.getText()}")
    @el

  setupAreaSelector: ->
    if @editor.getMode() is "view"
      @areaSelector?.remove()
    else
      @areaSelector?.remove()
      @areaSelector = $('img', @el).imgAreaSelect(handles: true, instance: true, parent: '.doc', zIndex: 2, onSelectEnd: @areaSelected, onSelectTerminated: @selectionCanceled)

  offsetTop: ->
    @el.offsetTop

  offsetBottom: ->
    @el.offsetTop + @el.offsetHeight

  scrollBottom: ->
    return 0 unless @el.offsetParent
    @el.offsetHeight - (@el.offsetTop - @el.offsetParent.scrollTop)

  isWithinViewport: (viewport_scroll_top) ->
    Math.abs(@offsetTop() - viewport_scroll_top) < 200

  isVisible: (viewport) ->
    @offsetTop() < viewport.bottom and not(@offsetBottom() < viewport.top)

  areaSelected: (img, selection) =>
    @newCommentView.forSelection(area: selection)

  selectionCanceled: (img) =>
    @newCommentView.hide()

  prepareComments: ->
    @newCommentView = new CommentView(model: new Comment(), parentView: @, page: @model, editor: @editor, onSuccess: @commentCreated)

  renderComments: ->
    @model.comments.each (comment) =>
      @renderComment(comment)

  renderComment: (comment) =>
    commentView = new CommentView(model: comment, editor: @editor, parentView: @).render()
    $(@el).prepend(commentView)

  commentCreated: (comment) =>
    @areaSelector.cancelSelection()
    @model.comments.add(comment)
    @editor.setMode("view")

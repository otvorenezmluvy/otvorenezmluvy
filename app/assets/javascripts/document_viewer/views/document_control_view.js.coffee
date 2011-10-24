class window.DocumentControlView extends Backbone.View
  events:
    "click ._dv_document_scan":     "showScan",
    "click ._dv_document_fulltext": "showFulltext"
    "click ._dv_add_comment":       "toggleCommentingMode"

  initialize: (options) ->
    @prepareContent()
    @editor = options.editor
    @editor.bind("document:change:type", @disableOrEnableCommentingButton, @)
    @editor.bind("document:switch", @documentSwitched, @)
    @editor.bind("document:change:mode", @updateDocumentMode, @)
    @documentSwitched()

  prepareContent: ->
    @scanButton = $('._dv_document_scan')
    @fulltextButton = $('._dv_document_fulltext')
    @commentButton = $('._dv_add_comment')

  showScan: ->
    @editor.showScan()
    false

  showFulltext: ->
    @editor.showFulltext()
    false

  toggleCommentingMode: ->
    @editor.toggleCommentingMode()
    false

  disableOrEnableCommentingButton: ->
    if @editor.getType() is "fulltext"
      @scanButton.removeClass("selected")
      @fulltextButton.addClass("selected")
      @commentButton.hide()
    if @editor.getType() is "scan"
      @fulltextButton.removeClass("selected")
      @scanButton.addClass("selected")
      @commentButton.show()

  updateDocumentMode: ->
    @commentButton.addClass("selected") if @editor.getMode() is "comment"
    @commentButton.removeClass("selected") if @editor.getMode() is "view"

  documentSwitched: ->
    @disableOrEnableCommentingButton()
    @updateDocumentMode()

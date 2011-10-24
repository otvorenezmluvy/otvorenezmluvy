class window.DocumentSelectorView extends Backbone.View

  initialize: (options) ->
    @editor = options.editor
    @editor.bind("change", @render, @)

  events:
    "change": "switchCurrentDocument"

  render: -> 
    if @editor.documents.size() > 1
      @el.html(@buildDocumentOptions())
    else
      @el.hide()

  buildDocumentOptions: ->
    @editor.documents.reduce ((memo, document) => memo + @buildOption(document)), ""

  buildOption: (document) ->
    if @editor.isDisplayed(document)
      "<option value='#{document.get("number")}' selected='selected'>#{document.get("name")}</option>"
    else
      "<option value='#{document.get("number")}'>#{document.get("name")}</option>"

  switchCurrentDocument: ->
    @editor.setCurrent(document_number: @el.val())

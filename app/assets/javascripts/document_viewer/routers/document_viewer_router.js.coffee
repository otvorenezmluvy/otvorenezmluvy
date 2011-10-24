class window.DocumentViewerRouter extends Backbone.Router
  initialize: (options) ->
    @editor = new Editor(
      documents: DocumentsBuilder.build(options),
      currentUser: options.currentUser,
      onReply: options.onReply,
      onShowReplies: options.onShowReplies)

    @editor.bind("document:change", @updatePageRoute, @)
    @editor.bind("document:switch", @updatePageRoute, @)

    @editor_views =
      [new NavigationView(editor: @editor, el: $('._dv_page_nav')),
       new DocumentView(editor: @editor, el: $('._dv_document')),
       new DocumentControlView(editor: @editor, el: $('._dv_document_control')),
       new DocumentSelectorView(editor: @editor, el: $('#_dv_attachment_selector'))]

    _(@editor_views).invoke('render')

  routes:
    "/document/:document/page/:page/comment/:comment": "goToDocumentPageComment"
    "/document/:document/page/:page": "goToDocumentPage"
    "": "index"

  goToDocumentPage: (document, page) ->
    @editor.setCurrent(document_number: document, page_number: page)
    @updatePageRoute()

  goToDocumentPageComment: (document, page, comment) ->
    @editor.setCurrent(document_number: document, page_number: page, comment: comment)

  index: ->
    @editor.setCurrent(document_number: 1, page_number: 1)

  updatePageRoute: ->
    @navigate("/document/#{@editor.get("current_document_number")}/page/#{@editor.getCurrentPageNumber()}")

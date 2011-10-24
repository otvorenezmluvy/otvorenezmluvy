class window.Editor extends Backbone.Model

  initialize: (options) ->
    @set(current_user: options.currentUser)
    @set(on_reply: options.onReply)
    @set(on_show_replies: options.onShowReplies)
    @documents = new Documents(options.documents)
    @documents.each (document) =>
      document.bind("all", (eventName) => @trigger("document:#{eventName}"))

    methods = ['previousPage', 'getCurrentDocumentNumber': 'getNumber', 'nextPage', 'showScan', 'getPages', 'getTotalPages', 'getCurrentPageNumber', 'getType', 'toggleCommentingMode', 'getMode', 'setMode']
    delegate(methods, {from: @, to: @getCurrentDocument})

  defaults:
    current_document_number: 1

  isDisplayed: (document) ->
    @getCurrentDocument() == document

  getCurrentDocument: =>
    @documents.at(@get("current_document_number") - 1)

  setCurrent: (options) ->
    if options.document_number and @get("current_document_number") != parseInt(options.document_number)
      @getCurrentDocument().setMode("view")
      @set(current_document_number: options.document_number)
      @trigger("document:switch")

    if options.page_number
      @getCurrentDocument().setCurrentPageNumber(options.page_number)
    else
      @getCurrentDocument().setCurrentPageNumber(1)

    if options.comment
      @getCurrentDocument().getCurrentPage().showComment(parseInt(options.comment))

  showFulltext: ->
    @getCurrentDocument().showFulltext()
    @getCurrentDocument().setMode("view")

  validate: (options) ->
    if typeof options.current_document_number != "undefined"
      options.current_document_number = parseInt(options.current_document_number)
    return

  getCurrentUser: ->
    @get("current_user")

  onReplyCallback: ->
    @get("on_reply")

  onShowRepliesCallback: ->
    @get("on_show_replies")

class window.Page extends Backbone.Model
  defaults:
    hidden: true,
    type: "scan"

  initialize: (options) ->
    @comments = new Comments(options.comments)

  setAttachment: (attachment) ->
    @attachment = attachment

  show: ->
    @set(hidden: false)

  hide: ->
    @set({hidden: true}, {silent: true})

  showFulltext: ->
    @set(type: "fulltext")

  showScan: ->
    @set(type: "scan")

  getText: ->
    @get("text") or @loadText()

  loadText: ->
    $.get(@get("textUrl"), (data) => @set(text: data))

  getNumber: ->
    @get("number")

  showComment: (commentId) ->
    comment = @comments.detect (comment) -> comment.get("id") == commentId
    comment.show() if comment

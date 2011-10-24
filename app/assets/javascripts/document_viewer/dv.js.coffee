//=require_tree .

class window.DocumentViewer
  @init = (options) ->
    router = new DocumentViewerRouter(options)
    Backbone.history.start()
    @

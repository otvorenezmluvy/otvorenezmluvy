class window.DocumentsBuilder
  @build = (options) ->
    _(options.attachments).map (attachment) ->
      new Document(attachment)

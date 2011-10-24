class window.Documents extends Backbone.Collection
  model: Document

  comparator: (document) ->
    document.getNumber()



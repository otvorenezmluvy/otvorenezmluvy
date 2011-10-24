class window.Pages extends Backbone.Collection
  model: Page

  comparator: (page) ->
    page.getNumber()

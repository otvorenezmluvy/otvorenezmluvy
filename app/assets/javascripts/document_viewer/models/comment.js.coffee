class window.Comment extends Backbone.Model
  url: ->
    location.href.replace(location.hash, '') + '/comments'

  initialize: (options) ->
    @set(area: $.parseJSON(options.area)) if options.area
    @set(created_at: new Date(options.created_at)) if options.created_at

  show: ->
    @trigger("highlight")

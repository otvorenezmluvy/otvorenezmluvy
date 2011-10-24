class window.NotificationView extends Backbone.View
  tagName: 'a'
  className: 'pencil2'

  isPermanentlyInterested: false

  events:
    "mouseover": "interested"
    "mouseout" : "lostInterest"
    "click"    : "permanentlyInterested"

  initialize: (options) ->
    @position = options.position
    @whenInterested = options.whenInterested
    @whenLostInterest = options.whenLostInterest

  render: ->
    $(@el).css
      "z-index":   1
      float:       'right'
      display:     'inline-block'
      position:    'absolute'
      top:         @position
      right:       '20px'

  interested: ->
    $(@el).removeClass('pencil2')
    $(@el).addClass('pencil1')
    @whenInterested()

  lostInterest: ->
    return if @isPermanentlyInterested
    $(@el).removeClass('pencil1')
    $(@el).removeClass('pencil3')
    $(@el).addClass('pencil2')
    @whenLostInterest()

  permanentlyInterested: ->
    if @isPermanentlyInterested
      @isPermanentlyInterested = false
      @lostInterest()
    else
      $(@el).removeClass('pencil1')
      $(@el).removeClass('pencil2')
      $(@el).addClass('pencil3')
      @whenInterested()
      @isPermanentlyInterested = true
    false

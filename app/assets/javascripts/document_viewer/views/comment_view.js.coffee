class window.CommentView extends Backbone.View
  tagName: 'div'
  className: 'comment'
  alreadyRendered: false

  rightMargin: 60
  commentPopupPadding: 40

  existingCommentTemplate: _.template(
    """
    <div class="note_box up_box">
      <div class="up_box_top"></div>
        <div class="up_box_center">
          <p class="author"><%= author %>, <%= date %></p>
          <p><%= comment %></p>
          <a href="#" class='reply'>Odpovedať</a><a href="#" class='show_replies'>Zobraziť reakcie</a>
        </div>
      <div class="up_box_bottom"></div>
    </div>
    """)

  commentAreaTemplate: _.template(
    """
    <div class='comment_area'></div>
    """
  )

  newCommentTemplate: _.template(
    """
    <div class="add_note_box up_box">
      <div class="up_box_top"></div>
      <div class="up_box_center">
        <p class="user">
          Prispievate ako <strong><%= user %></strong>
        </p>
        <form method="get" action="">
          <label>Poznámka</label>
          <textarea rows="" cols="" name="note"></textarea>
          <div class="buttons2">
            <input type="submit" value="Pridať poznámku" class="submit button">
            <a href="#" class="cancel">Zrušiť</a>
          </div>
        </form>
      </div>
      <div class="up_box_bottom"></div>
    </div>
    """
  )

  initialize: (options) ->
    @parentView = options.parentView
    @page = options.page
    @editor = options.editor
    @onSuccess = options.onSuccess
    @model.bind("highlight", @highlight, @)

  prepareContent: (template) ->
    @commentTextArea = $('textarea', template)
    @saveButton = $('*[type=submit]', template)
    @saveButton.click(@processForm)
    $('a.cancel', template).click =>
      @editor.toggleCommentingMode()
      false

  render: ->
    return if @alreadyRendered
    if @model.get("comment") and @model.get("area")
      @renderExistingComment()
    else
      @renderNewComment()
    @alreadyRendered = true

  renderNewComment: ->
    $newComment = $(@newCommentTemplate(user: @editor.getCurrentUser()))
    @prepareContent($newComment)

    $el = $(@el)
    $el.append($newComment)
    $el.css('z-index': 99999)
    $el.appendTo(@parentView.el)

  renderExistingComment: ->
    $area = $(@commentAreaTemplate())
    $area.css
      "z-index": 99
      position: 'absolute'
      display:  'none'
      top:      @model.get("area").y1
      left:     @model.get("area").x1
      width:    @model.get("area").width
      height:   @model.get("area").height

    comment = @existingCommentTemplate
      author:  @model.get('author_label')
      comment: @model.get("comment")
      date:    DateFormat.format(@model.get("created_at"))
    $comment = $(comment)
    $comment.css
      display: 'none'
    $('.reply', $comment).click =>
      @editor.onReplyCallback().apply(@, [@model.get("id"), @model.get("comment")])
      false
    $('.show_replies', $comment).click =>
      @editor.onShowRepliesCallback().apply(@, [@model.get("id")])
      false

    @notification = new NotificationView(
      position: @model.get("area").y1,
      whenInterested: =>
        $area.css(display: 'inline-block')
        placement = @calculatePlacement($comment)
        $comment.css
          "z-index":   99
          display:  'inline-block'
          position: 'absolute'
          width:    placement.width
          left:     placement.left
          top:      placement.top

      whenLostInterest: =>
        $area.css(display: 'none')
        $comment.css(display: 'none')
    )

    $wrap = $('<div/>')
    $wrap.append($area).append($comment).append(@notification.render())
    $wrap.appendTo(@parentView.el)

  calculatePlacement: (element = @el) ->
    placement = {}
    placement.top   = @model.get("area").y1 + @model.get("area").height + 20

    if element and @parentView.scrollBottom() - placement.top < $(element).height() + @commentPopupPadding
      placement.top = @model.get("area").y1 - $(element).height() - @commentPopupPadding

    placement.width = @parentView.el.offsetWidth - @rightMargin - @commentPopupPadding
    placement.left  = @commentPopupPadding / 2
    placement


  forSelection: (options) ->
    @model.set(area: options.area)
    @render()
    placement = @calculatePlacement()
    $(@el).css
      position: 'absolute'
      top: placement.top
      left: placement.left
    if placement.top < options.area.y1
      $(@el).addClass("reverse_note_box")
    else
      $(@el).removeClass("reverse_note_box")

    $(@el).show()
    @commentTextArea.focus()

  hide: ->
    $(@el).empty().remove()
    @alreadyRendered = false

  processForm: =>
    @model.set(comment: @commentTextArea.val())
    @model.set(page_number: @page.getNumber())
    @model.set(attachment_number: @page.attachment.getNumber())
    @model.set(author_label: @editor.getCurrentUser())
    @model.set(created_at: new Date())
    #@model.save({}, success: @commentSaved)
    @model.save()
    @hide()
    @commentTextArea.val('')
    @onSuccess(@model)

  highlight: =>
    @notification.permanentlyInterested()
    @parentView.el.scrollIntoView()

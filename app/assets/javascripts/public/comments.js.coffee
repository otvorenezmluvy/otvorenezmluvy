class CommentView extends Backbone.View
  initialize: (options) ->
    @newCommentView = options.newCommentView
    @currentVotes = @$('.current_votes')
    @messages = @$('.messages')

  events:
    "click .reply": "replyToComment"
    "click .delete": "deleteComment"
    "click .vote_up": "vote"
    "click .vote_down": "vote"
    "click .flag": "flag"

  replyToComment: ->
    @newCommentView.replyTo(@currentCommentId(), @$('.text').text())
    false

  message: (text) ->
    @messages.html(text)
    setTimeout((=> @messages.html('')), 2000)

  deleteComment: (e) ->
    if confirm($(e.target).data('confirm'))
      $.ajax
        type: 'DELETE'
        url: $(e.target).attr('href')
        success: =>
          comment = $(e.target).parents('.comment-top:first')
          $('.comment', comment).html('Komentár bol zmazaný')
          setTimeout((=> comment.remove()), 2000)
    false

  commentDeleted: =>
    @remove()

  currentCommentId: ->
    @$('.reply').data('reply-to')

  vote: (e) ->
    $.ajax
      type: 'POST'
      url: $(e.target).attr('href')
      success: (data) => @currentVotes.text(data.votes)
      error: @onVoteError
      dataType: 'json'
    false

  onVoteError: (jqXHR, textStatus, error) =>
    if jqXHR.status == 401
      @messages.html('Pre hlasovanie sa musíte prihlásiť')
    else if jqXHR.status == 403
      @messages.html('Za tento komentár ste už hlasovali')
    setTimeout((=> @messages.html('')), 2000)

  flag: (e) ->
    $.ajax
      type: 'POST'
      dataType: 'json'
      url: $(e.target).attr('href')
      success: (data) =>
        @messages.html('Komentár bol nahlásený')
        setTimeout((=> @messages.html('')), 2000)
      error: (jqXHR, textStatus, error) =>
        @messages.html('Pri nahlasovaní komentára sa vyskytla chyba')
        setTimeout((=> @messages.html('')), 2000)
    reportView = new FlaggedCommentReportView(parent: this, pageY: e.pageY, flagUrl: $(e.target).data('reason-url'))
    reportView.render()
    false

class NewCommentView extends Backbone.View
  initialize: ->
    @commentTextArea = @$('#comment_comment')
    @replyToInput = @$('#comment_reply_to')
    @ajaxLoader = @$('.ajax-loader')
    @inReplyTo = @$('.in-reply-to')

  events:
    "click *[type=submit]": "submitComment"
    "click .cancel_reply": "cancelReply"

  replyTo: (commentId, commentText) ->
    @replyToInput.val(commentId)
    @el[0].scrollIntoView()
    @commentTextArea.focus()
    @inReplyTo.html("<strong>Odpovedáte na komentár:</strong> #{commentText} <a href='#' class='cancel_reply'>(✖ zrušiť)</a>")

  cancelReply: ->
    @replyToInput.val('')
    @inReplyTo.html('')
    false

  submitComment: ->
    $form = @$('form')
    $.post($form.attr('action'), $form.serializeArray(), @onCommentSuccess, 'json')
    @ajaxLoader.show()
    false

  replying: ->
    @replyToInput.val() != ""

  onCommentSuccess: (data) =>
    @$('.errors').remove()
    if data.errors
      @$('textarea').before(data.errors)
    else
      if @replying()
        @withNewView(data.template, (comment) -> $("#comment_#{@replyToInput.val()}").replaceWith(comment))
      else
        @withNewView(data.template, (comment) -> $('#comments').prepend(comment))

      @cancelReply()
      @commentTextArea.val('')

    @ajaxLoader.hide()
    Recaptcha?.reload()

  withNewView: (template, fn) ->
      newComment = $(template)
      fn.apply(@, [newComment])
      $('.comment-box', newComment).each (idx, comment) =>
        new CommentView(el: comment, newCommentView: @)

class FlaggedCommentReportView extends Backbone.View
  dialogTemplate: _.template(
    """
    <div class="document">
      <div class="add_note_box up_box">
        <div class="up_box_top"></div>
        <div class="up_box_center">
          <form method="get" action="">
            <label>Zdôvodnenie</label>
            <textarea rows="" cols="" name="note"></textarea>
            <div class="buttons2">
              <input type="submit" value="Pridať zdôvodnenie" class="submit button">
              <a href="#" class="cancel">Ponechať nahlásenie bez zdôvodnenia</a>
            </div>
          </form>
        </div>
        <div class="up_box_bottom"></div>
      </div>
    </div>
    """
  )

  events:
    'click .cancel': 'cancel'
    'click .submit': 'submit'

  initialize: (options) ->
    @parent = options.parent
    @pageY = options.pageY
    @flagUrl = options.flagUrl

  render: ->
    $dialog = $(@dialogTemplate())
    $dialog.css
      "z-index": 99
      position: 'absolute'
      top:      @pageY
      right:    0
    $(@el).html($dialog)
    $(@parent.el).append(@el)

  cancel: ->
    $(@el).remove()
    false

  submit: (e) ->
    $.ajax
      type: 'POST'
      url: @flagUrl
      data: { note: $('textarea[name="note"]', $(@el)).val() }
      success: =>
        @cancel()
        @parent.message('Zdôvodnenie bolo pridané.')
      error: (jqXHR, textStatus, error) =>
        @parent.message('Pri nahlasovaní zdôvodnenia sa vyskytla chyba.')

    false

class Comments
  constructor: ->
    @newCommentView = new NewCommentView(el: $('.new-comment'))
    $('.comment-box').each (idx, comment) =>
      new CommentView(el: comment, newCommentView: @newCommentView)

  replyTo: (commentId, commentText) =>
    @newCommentView.replyTo(commentId, commentText)

  showComment: (commentId) ->
    $("#comment_#{commentId}")[0].scrollIntoView()


$ ->
  comments = new Comments()
  window.CrowdCloud ||= {}
  window.CrowdCloud.Comments = comments

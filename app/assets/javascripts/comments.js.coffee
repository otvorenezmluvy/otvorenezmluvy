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

  replyToComment: ->
    @newCommentView.replyTo(@currentCommentId(), @$('.text').text())
    false

  deleteComment: (e) ->
    if confirm($(e.target).data('confirm'))
      $.ajax
        type: 'DELETE'
        url: $(e.target).attr('href')
        success: -> $(e.target).parents('.comment-top:first').remove()
    false

  commentDeleted: =>
    @remove()

  currentCommentId: ->
    @$('.reply').data('reply-to')

  vote: (e) ->
    $.ajax
      type: 'GET'
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
        @withNewView(data.template, (comment) -> $("#comment_#{@replyToInput.val()}").html(comment))
      else
        @withNewView(data.template, (comment) -> $('#comments').prepend(comment))

      @cancelReply()
      @commentTextArea.val('')

    @ajaxLoader.hide()
    Recaptcha?.reload()

  withNewView: (template, fn) ->
      newComment = $(template)
      fn.apply(@, [newComment])
      new CommentView(el: newComment, newCommentView: @)

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

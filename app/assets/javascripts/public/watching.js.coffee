class WatchingView extends Backbone.View


  el: $(
    """
      <div class="small_box">
        <div class="small_box_top"></div>
        <div class="small_box_center">
          <div class="info">
            <p>Zmluva bola pridaná medzi sledované zmluvy.</p>
            <p><a href="#" class="add_comment">+Pridať poznámku k zmluve</a></p>
          </div>
          <form>
            <label>Poznámka</label>
            <textarea></textarea>
            <div class="buttons2">
              <input type="submit" class="submit button" value="Pridať poznámku"/>
              <a href="#" class="cancel">Bez poznámky</a>
            </div>
          <form>
        </div>
        <div class="small_box_bottom"></div>
      </div>
    """)

  initialize: (options) ->
    @watchUrl = options.watchUrl
    @watchControl = options.watchControl

  events:
    "click .add_comment": "showCommentForm"
    "click .submit": "addNote"
    "click .cancel": "hide"

  show: ->
    @watchControl.after(@el)

  hide: ->
    $(@el).remove()
    false

  showCommentForm: ->
    @$('.info').hide()
    @$('form').show()
    false

  addNote: (e) ->
    note = @$('textarea').val()
    $.post(@watchUrl, { notice: note })
    $(@el).hide()
    @watchControl.addClass('with_note').attr('title', note)
    false

$ ->
  $('.unwatched').live 'click', ->
    watchUrl = $(this).data('watch-url')
    $.post(watchUrl)
    $(this).removeClass('unwatched')
    $(this).addClass('watched')
    $(this).text("Sledované")
    new WatchingView(watchUrl: watchUrl, watchControl: $(this)).show()
    false

  $('.watched').live 'click', ->
    $.post($(this).data('unwatch-url'))
    $(this).removeClass('watched')
    $(this).addClass('unwatched')
    $(this).text("Sledovať")
    false

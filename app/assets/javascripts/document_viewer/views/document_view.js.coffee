class window.DocumentView extends Backbone.View

  autoScrollEnabled: true

  events:
    "mousedown" : "startDragScroll",
    "mouseup"   : "stopDragScroll",
    "mousemove" : "dragScroll",
    "mouseleave": "stopDragScroll",
    "scroll"    : "documentScrolled"

  documents: {}
  pageViews: {}

  initialize: (options) ->
    @editor = options.editor
    @editor.bind("document:change:current_page", @autoScrollToCurrentPage, @)
    @editor.bind("document:switch", @documentSwitched, @)
    @editor.bind("document:change:mode", @documentModeChanged, @)
    @editor.bind("document:change:type", @documentModeChanged, @)
    @setupStyles()
    @reloadPageViews()
    @setupDocumentMode()

  setupStyles: ->
    @el.css(overflow: 'hidden', position: 'relative', height: '990px')

  startDragScroll: (e) =>
    return unless @draggingAllowed()
    if e.button is 0
      @el.css("cursor": Browser.cursor('grabbing'))
      @dragging=e
      e.preventDefault()
      e.stopPropagation()

  stopDragScroll: (e) =>
    return unless @draggingAllowed()
    @el.css("cursor": Browser.cursor('grab'))
    @dragging = false

  dragScroll: (e) =>
    return unless @draggingAllowed()
    if @dragging
      @elDOM().scrollTop = @elDOM().scrollTop + (@dragging.clientY - e.clientY)
      @dragging = e
      e.preventDefault()
      e.stopPropagation()

  draggingAllowed: ->
    @editor.getMode() is "view" and @editor.getType() is "scan"

  elDOM: ->
    @el[0]

  autoScrollToCurrentPage: =>
    if @autoScrollEnabled
      currentPageNumber = @editor.getCurrentPageNumber()
      currentPage = @pageViews[currentPageNumber]
      @elDOM().scrollTop = currentPage.offsetTop()

  reloadPageViews: ->
    if @documents[@editor.getCurrentDocumentNumber()]
      @pageViews = @documents[@editor.getCurrentDocumentNumber()]
    else
      @pageViews = {}
      @editor.getPages().each (page) => @pageViews[page.getNumber()] = new PageView(editor: @editor, model: page)
      @documents[@editor.getCurrentDocumentNumber()] = @pageViews

    @el.empty()
    _(@pageViews).each (pageView) => @el.append(pageView.render())
    @hideAndShowVisiblePages()

  render: =>
    _(@pageViews).invoke("render")
    @hideAndShowVisiblePages()

  documentScrolled: ->
    @syncCurrentPageNumber()
    @hideAndShowVisiblePages()

  syncCurrentPageNumber: ->
    pageInViewPort = _.detect(@pageViews, (pageView) => pageView.isWithinViewport(@elDOM().scrollTop))
    if pageInViewPort
      @withDisabledAutoscroll =>
        @editor.setCurrent(page_number: pageInViewPort.model.get("number"))

  hideAndShowVisiblePages: ->
    viewport = {}
    viewport.bottom = @elDOM().scrollTop + @elDOM().offsetHeight
    viewport.top    = @elDOM().scrollTop

    visible = _(@pageViews).select((pageView) => pageView.isVisible(viewport))
    hidden  = _(@pageViews).difference(visible)
    _(visible).each (pageView) -> pageView.model.show()
    _(hidden).each  (pageView) -> pageView.model.hide()

  withDisabledAutoscroll: (action) ->
    @autoScrollEnabled = false
    action()
    @autoScrollEnabled = true

  documentModeChanged: ->
    @setupDocumentMode()
    @render()

  documentSwitched: ->
    @reloadPageViews()
    @setupDocumentMode()

  setupDocumentMode: ->
    @el.css("cursor": "crosshair") if @editor.getMode() is "comment"
    @el.css("cursor": Browser.cursor('grab')) if @draggingAllowed()
    @el.css("cursor": "text") if @editor.getMode() is "view" and @editor.getType() is "fulltext"

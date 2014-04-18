'use strict'
$.DropdownNav = Backbone.View.extend(
  el: 'li'
  initialize: (options) ->
    @opt = {
      transitionDuration: 0
    }
    $.extend(@opt, options)
    _.bindAll(this, 'update', 'handler', 'closeAll')
    setTimeout @update, 500
    lazyUpdate = _.debounce(@update, 500)
    $(window).on 'resize orientationchange', lazyUpdate
    @opened = false
    null

  update: ->
    self = this
    @$el.each (i, el) ->
      $el = $(el)
      $child = $el.find('ul')
      if $child[0]?
        $child.css
          height: ''
          visibility: 'hidden'
        el.childheight = $child.height() # save height
        $child.css
          height: 0
          visibility: 'visible'
        el.$child = $child
      $link = $el.find('>a')
      if $link[0]
        $link.data 'container',  el
        $link.on 'click', self.handler
      else
        $el.on 'click', self.handler
      null

  handler: (e) ->
    target = e.currentTarget
    if $(target).data('container') then target = $(target).data('container')
    if !target.$child?
      @closeAll(target)
      @opened = false
      return true
    e.preventDefault()

    @closeAll(target).done ->
      if target.$child.hasClass('on')
        # off
        target.$child.removeClass('on').height(0)
      else
        # on
        target.$child.addClass('on').height(target.childheight)
    @opened = true
    null
  closeAll: (exclude) ->
    dfd = $.Deferred()
    @$el.each (i, el) ->
      $child = $(el).find('ul')
      if el isnt exclude and $child.hasClass('on')
        $child.removeClass('on').height(0)
      null
    if @opened is true
      setTimeout dfd.resolve, @opt.transitionDuration
    else
      dfd.resolve()
    dfd.promise()
)

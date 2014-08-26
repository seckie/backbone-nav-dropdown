###
 * $.NavDropdown
 *
 * @author     Naoki Sekiguchi
 * @license    MIT
 * @require    jquery.js, underscore.js, backbone.js
###

((Backbone, _, $, window) ->
  'use strict'

  $.NavDropdown = Backbone.View.extend(
    el: 'li'
    initialize: (options) ->
      @opt = {
        transitionDuration: 250
        child: 'ul'
        activeClass: 'on'
      }
      $.extend(@opt, options)
      _.bindAll(@, 'render', 'update', 'handler', 'closeAll')
      setTimeout @render, 500
      $(window).on 'resize orientationchange', _.debounce(@update, 500)
      @opened = false
      return

    render: ->
      self = @
      errorMsg = '$.NavDropdown: child element not found'
      @$el.each (i, el) ->
        $el = $(el)
        $link = $el.find('>a')
        if $link[0]
          $link.data 'container', el
          $link.on 'click', self.handler
        else
          $el.on 'click', self.handler

        if self.opt.child is null
          if $link[0]
            $child = $($link.attr('href'))
            if !$child[0]?
              return # nothing to do
          else
            console.error errorMsg
            return
        else
          $child = $el.find(self.opt.child)

        if $child[0]?
          $el.data('$child', $child)
        return
      @update()
      
    update: ->
      @$el.each (i, el) ->
        $el = $(el)
        $child = $el.data('$child')
        if $child?[0]?
          $child.css
            height: ''
            visibility: 'hidden'
          $el.data('childheight', $child.height()) # save height
          $child.css
            height: 0
            visibility: 'visible'
          $el.data('$child', $child)
        return

    handler: (e) ->
      self = @
      trigger = e.currentTarget
      if $(trigger).data('container')
        trigger = $(trigger).data('container')
      $trigger = $(trigger)
      $child = $trigger.data('$child')
      if !$child?
        @closeAll(trigger)
        @opened = false
        return true # default link

      @closeAll(trigger).done ->
        if $trigger.hasClass(self.opt.activeClass)
          # off
          $trigger.removeClass(self.opt.activeClass)
          $child.height(0)
        else
          # on
          $trigger.addClass(self.opt.activeClass)
          $child.height($trigger.data('childheight'))
      @opened = true

      @trigger('change', trigger) # event
      e.preventDefault()
      return

    closeAll: (exclude) ->
      self = @
      dfd = $.Deferred()
      @$el.each (i, el) ->
        $el = $(el)
        $child = $el.data('$child')
        if el isnt exclude
          if $child? and $child[0] and $el.hasClass(self.opt.activeClass)
            $el.removeClass(self.opt.activeClass)
            $child.height(0)
        return
      if @opened is true
        setTimeout dfd.resolve, @opt.transitionDuration
      else
        dfd.resolve()
      dfd.promise()
  )

  return
)(Backbone, _, jQuery, window)

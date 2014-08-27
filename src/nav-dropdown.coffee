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
        transitionClass: 'trans'
        child: 'ul'
        activeClass: 'on'
      }
      $.extend(@opt, options)
      _.bindAll(@, 'render', 'update', 'handler', 'open', 'closeAll')
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
      self = @
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
      if self.current
        self.closeAll().done () ->
          self.open(self.current)
      return

    handler: (e) ->
      trigger = e.currentTarget
      if $(trigger).data('container')
        trigger = $(trigger).data('container')
      @open(trigger)

      @trigger('change', trigger) # event
      e.preventDefault()
      return

    open: (trigger) ->
      self = @
      $trigger = $(trigger)
      $child = $trigger.data('$child')
      end = ($el) ->
        setTimeout(() ->
          $el.removeClass(self.opt.transitionClass).height('')
          self.blocking = false
          return
        , self.opt.transitionDuration)

      if @blocking is true
        return
      if !$child?
        @closeAll(trigger)
        @opened = false
        return true # default link

      @closeAll(trigger).done ->
          
        if $trigger.hasClass(self.opt.activeClass)
          # off
          $trigger.removeClass(self.opt.activeClass)
          $child.addClass(self.opt.transitionClass)
            .height(0)
          end($child)
        else
          # on
          $trigger.addClass(self.opt.activeClass)
          $child.addClass(self.opt.transitionClass)
            .height($trigger.data('childheight'))
          end($child)
        return
      @opened = true
      @current = trigger
      return

    closeAll: (exclude) ->
      self = @
      dfd = $.Deferred()
      if @blocking is true
        return
      @blocking = true
      @$el.each (i, el) ->
        $el = $(el)
        $child = $el.data('$child')
        if el isnt exclude
          if $child? and $child[0] and $el.hasClass(self.opt.activeClass)
            $el.removeClass(self.opt.activeClass)
            $child.addClass(self.opt.transitionClass)
              .height(0)
        return
      if @opened is true
        setTimeout(() ->
#           self.$el.each((i, el) ->
#             $child = $(el).data('$child')
#             $child.removeClass(self.opt.transitionClass) if $child?
#           )
          dfd.resolve()
        , @opt.transitionDuration)
      else
        setTimeout(() ->
          self.blocking = false
          dfd.resolve()
        , @opt.transitionDuration)
      dfd.promise()
  )

  return
)(Backbone, _, jQuery, window)

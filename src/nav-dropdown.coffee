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
        events: 'resize orientationchange'
      }
      @ERRORMSG1 = '$.NavDropdown: child element not found'
      $.extend(@opt, options)
      _.bindAll(@, 'render', 'update', 'handler',
        'open', 'close', 'closeAll', 'closeAllEnd')
      setTimeout(@render, 500)
      $(window).on(@opt.events, _.debounce(@update, 500))
      return

    render: ->
      self = @
      @$el.each (i, el) ->
        $el = $(el)
        $link = $el.find('>a')
        if $link[0]
          $link.data('container', el)
          $link.on('click', self.handler)
        else
          $el.on('click', self.handler)

        if self.opt.child is null # tab & content mode
          if $link[0]
            href = $link.attr('href')
            $child = $(href.slice(href.lastIndexOf('#')))
            if !$child[0]?
              return # nothing to do
          else
            console.error(self.ERRORMSG1)
            return
        else # child menu mode
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
          self.blocking = false
          self.open(self.current)
      return

    handler: (e) ->
      self = @
      trigger = e.currentTarget
      $trigger = $(trigger)
      if $(trigger).data('container')
        trigger = $(trigger).data('container')
        $trigger = $(trigger)
      $child = $trigger.data('$child')

      if @blocking is true
        return
      if !$child?
        @closeAll(trigger)
        @blocking = false
        return true # default link
      else
        @closeAll(trigger).done(() ->
          if $trigger.hasClass(self.opt.activeClass)
            self.close(trigger, $child)
          else
            self.open(trigger, $child)
        )

      @trigger('change', trigger) # event
      e.preventDefault()
      return

    open: (trigger, $child) ->
      self = @
      $trigger = $(trigger)
      $child = $child ? $trigger.data('$child')

      $trigger.addClass(self.opt.activeClass)
      $child.addClass(self.opt.transitionClass)
        .height($trigger.data('childheight'))

      setTimeout(() ->
        $child.removeClass(self.opt.transitionClass)#.height('')
        self.blocking = false
        return
      , @opt.transitionDuration)

      @current = trigger
      return

    close: (trigger, $child) ->
      self = @
      $trigger = $(trigger)
      $child = $child ? $trigger.data('$child')

      $trigger.removeClass(self.opt.activeClass)
      $child.height($trigger.data('childheight'))
        .addClass(self.opt.transitionClass)
        .height(0)

      setTimeout(() ->
        $child.removeClass(self.opt.transitionClass)#.height('')
        self.blocking = false
        return
      , @opt.transitionDuration)

      @current = trigger
      return

    closeAll: (exclude) ->
      self = @
        
      if @blocking is true
        return
      @blocking = true
      @$el.each (i, el) ->
        $el = $(el)
        $child = $el.data('$child')
        if el is exclude
          return
        if $child? and $el.hasClass(self.opt.activeClass)
          $el.removeClass(self.opt.activeClass)
          $child.height($el.data('childheight'))
            .addClass(self.opt.transitionClass)
            .height(0)
        return
      @closeAllEnd()

    closeAllEnd: () ->
      self = @
      dfd = $.Deferred()
      setTimeout(() ->
        self.$el.each (i, el) ->
          $child = $(el).data('$child')
          $child.removeClass(self.opt.transitionClass) if $child?
        dfd.resolve()
      , self.opt.transitionDuration)
      dfd.promise()
  )

  return
)(Backbone, _, jQuery, window)

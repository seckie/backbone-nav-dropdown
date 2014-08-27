
/*
 * $.NavDropdown
 *
 * @author     Naoki Sekiguchi
 * @license    MIT
 * @require    jquery.js, underscore.js, backbone.js
 */
(function(Backbone, _, $, window) {
  'use strict';
  $.NavDropdown = Backbone.View.extend({
    el: 'li',
    initialize: function(options) {
      this.opt = {
        transitionDuration: 250,
        transitionClass: 'trans',
        child: 'ul',
        activeClass: 'on'
      };
      $.extend(this.opt, options);
      _.bindAll(this, 'render', 'update', 'handler', 'open', 'closeAll');
      setTimeout(this.render, 500);
      $(window).on('resize orientationchange', _.debounce(this.update, 500));
      this.opened = false;
    },
    render: function() {
      var errorMsg, self;
      self = this;
      errorMsg = '$.NavDropdown: child element not found';
      this.$el.each(function(i, el) {
        var $child, $el, $link;
        $el = $(el);
        $link = $el.find('>a');
        if ($link[0]) {
          $link.data('container', el);
          $link.on('click', self.handler);
        } else {
          $el.on('click', self.handler);
        }
        if (self.opt.child === null) {
          if ($link[0]) {
            $child = $($link.attr('href'));
            if ($child[0] == null) {
              return;
            }
          } else {
            console.error(errorMsg);
            return;
          }
        } else {
          $child = $el.find(self.opt.child);
        }
        if ($child[0] != null) {
          $el.data('$child', $child);
        }
      });
      return this.update();
    },
    update: function() {
      var self;
      self = this;
      this.$el.each(function(i, el) {
        var $child, $el;
        $el = $(el);
        $child = $el.data('$child');
        if (($child != null ? $child[0] : void 0) != null) {
          $child.css({
            height: '',
            visibility: 'hidden'
          });
          $el.data('childheight', $child.height());
          $child.css({
            height: 0,
            visibility: 'visible'
          });
          $el.data('$child', $child);
        }
      });
      if (self.current) {
        self.closeAll().done(function() {
          return self.open(self.current);
        });
      }
    },
    handler: function(e) {
      var trigger;
      trigger = e.currentTarget;
      if ($(trigger).data('container')) {
        trigger = $(trigger).data('container');
      }
      this.open(trigger);
      this.trigger('change', trigger);
      e.preventDefault();
    },
    open: function(trigger) {
      var $child, $trigger, end, self;
      self = this;
      $trigger = $(trigger);
      $child = $trigger.data('$child');
      end = function($el) {
        return setTimeout(function() {
          return $el.removeClass(self.opt.transitionClass);
        }, self.opt.transitionDuration);
      };
      if ($child == null) {
        this.closeAll(trigger);
        this.opened = false;
        return true;
      }
      this.closeAll(trigger).done(function() {
        if ($trigger.hasClass(self.opt.activeClass)) {
          $trigger.removeClass(self.opt.activeClass);
          return $child.removeClass(self.opt.transitionClass).height(0);
        } else {
          $trigger.addClass(self.opt.activeClass);
          $child.addClass(self.opt.transitionClass).height($trigger.data('childheight'));
          return end($child);
        }
      });
      this.opened = true;
      this.current = trigger;
    },
    closeAll: function(exclude) {
      var dfd, self;
      self = this;
      dfd = $.Deferred();
      this.$el.each(function(i, el) {
        var $child, $el;
        $el = $(el);
        $child = $el.data('$child');
        if (el !== exclude) {
          if (($child != null) && $child[0] && $el.hasClass(self.opt.activeClass)) {
            $el.removeClass(self.opt.activeClass);
            $child.addClass(self.opt.transitionClass).height(0);
          }
        }
      });
      if (this.opened === true) {
        setTimeout(function() {
          self.$el.each(function(i, el) {
            var $child;
            $child = $(el).data('$child');
            if ($child != null) {
              return $child.removeClass(self.opt.transitionClass);
            }
          });
          return dfd.resolve();
        }, this.opt.transitionDuration);
      } else {
        dfd.resolve();
      }
      return dfd.promise();
    }
  });
})(Backbone, _, jQuery, window);

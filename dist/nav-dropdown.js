
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
      this.ERRORMSG1 = '$.NavDropdown: child element not found';
      $.extend(this.opt, options);
      _.bindAll(this, 'render', 'update', 'handler', 'open', 'close', 'closeAll', 'closeAllEnd');
      setTimeout(this.render, 500);
      $(window).on('resize orientationchange', _.debounce(this.update, 500));
    },
    render: function() {
      var self;
      self = this;
      this.$el.each(function(i, el) {
        var $child, $el, $link, href;
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
            href = $link.attr('href');
            $child = $(href.slice(href.lastIndexOf('#')));
            if ($child[0] == null) {
              return;
            }
          } else {
            console.error(self.ERRORMSG1);
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
          self.blocking = false;
          return self.open(self.current);
        });
      }
    },
    handler: function(e) {
      var $child, $trigger, self, trigger;
      self = this;
      trigger = e.currentTarget;
      $trigger = $(trigger);
      if ($(trigger).data('container')) {
        trigger = $(trigger).data('container');
        $trigger = $(trigger);
      }
      $child = $trigger.data('$child');
      if (this.blocking === true) {
        return;
      }
      if ($child == null) {
        this.closeAll(trigger);
        this.blocking = false;
        return true;
      } else {
        this.closeAll(trigger).done(function() {
          if ($trigger.hasClass(self.opt.activeClass)) {
            return self.close(trigger, $child);
          } else {
            return self.open(trigger, $child);
          }
        });
      }
      this.trigger('change', trigger);
      e.preventDefault();
    },
    open: function(trigger, $child) {
      var $trigger, self;
      self = this;
      $trigger = $(trigger);
      $child = $child != null ? $child : $trigger.data('$child');
      $trigger.addClass(self.opt.activeClass);
      $child.addClass(self.opt.transitionClass).height($trigger.data('childheight'));
      setTimeout(function() {
        $child.removeClass(self.opt.transitionClass);
        self.blocking = false;
      }, this.opt.transitionDuration);
      this.current = trigger;
    },
    close: function(trigger, $child) {
      var $trigger, self;
      self = this;
      $trigger = $(trigger);
      $child = $child != null ? $child : $trigger.data('$child');
      $trigger.removeClass(self.opt.activeClass);
      $child.height($trigger.data('childheight')).addClass(self.opt.transitionClass).height(0);
      setTimeout(function() {
        $child.removeClass(self.opt.transitionClass);
        self.blocking = false;
      }, this.opt.transitionDuration);
      this.current = trigger;
    },
    closeAll: function(exclude) {
      var self;
      self = this;
      if (this.blocking === true) {
        return;
      }
      this.blocking = true;
      this.$el.each(function(i, el) {
        var $child, $el;
        $el = $(el);
        $child = $el.data('$child');
        if (el === exclude) {
          return;
        }
        if (($child != null) && $el.hasClass(self.opt.activeClass)) {
          $el.removeClass(self.opt.activeClass);
          $child.height($el.data('childheight')).addClass(self.opt.transitionClass).height(0);
        }
      });
      return this.closeAllEnd();
    },
    closeAllEnd: function() {
      var dfd, self;
      self = this;
      dfd = $.Deferred();
      setTimeout(function() {
        self.$el.each(function(i, el) {
          var $child;
          $child = $(el).data('$child');
          if ($child != null) {
            return $child.removeClass(self.opt.transitionClass);
          }
        });
        return dfd.resolve();
      }, self.opt.transitionDuration);
      return dfd.promise();
    }
  });
})(Backbone, _, jQuery, window);

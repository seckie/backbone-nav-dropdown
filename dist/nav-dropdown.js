'use strict';
$.DropdownNav = Backbone.View.extend({
  el: 'li',
  initialize: function(options) {
    this.opt = {
      transitionDuration: 0,
      child: 'ul'
    };
    $.extend(this.opt, options);
    _.bindAll(this, 'update', 'handler', 'closeAll');
    setTimeout(this.update, 500);
    $(window).on('resize orientationchange', _.debounce(this.update, 500));
    this.opened = false;
  },
  update: function() {
    var errorMsg, self;
    self = this;
    errorMsg = '$.DropdownNav: child element not found';
    return this.$el.each(function(i, el) {
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
  },
  handler: function(e) {
    var $child, $trigger, trigger;
    trigger = e.currentTarget;
    if ($(trigger).data('container')) {
      trigger = $(trigger).data('container');
    }
    $trigger = $(trigger);
    $child = $trigger.data('$child');
    if ($child == null) {
      this.closeAll(trigger);
      this.opened = false;
      return true;
    }
    this.closeAll(trigger).done(function() {
      if ($child.hasClass('on')) {
        return $child.removeClass('on').height(0);
      } else {
        return $child.addClass('on').height($trigger.data('childheight'));
      }
    });
    this.opened = true;
    e.preventDefault();
  },
  closeAll: function(exclude) {
    var dfd;
    dfd = $.Deferred();
    this.$el.each(function(i, el) {
      var $child;
      $child = $(el).data('$child');
      if (el !== exclude) {
        if (($child != null) && $child[0] && $child.hasClass('on')) {
          $child.removeClass('on').height(0);
        }
      }
    });
    if (this.opened === true) {
      setTimeout(dfd.resolve, this.opt.transitionDuration);
    } else {
      dfd.resolve();
    }
    return dfd.promise();
  }
});

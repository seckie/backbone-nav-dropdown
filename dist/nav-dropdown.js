'use strict';
$.DropdownNav = Backbone.View.extend({
  el: 'li',
  initialize: function(options) {
    var lazyUpdate;
    this.opt = {
      transitionDuration: 0
    };
    $.extend(this.opt, options);
    _.bindAll(this, 'update', 'handler', 'closeAll');
    setTimeout(this.update, 500);
    lazyUpdate = _.debounce(this.update, 500);
    $(window).on('resize orientationchange', lazyUpdate);
    this.opened = false;
    return null;
  },
  update: function() {
    var self;
    self = this;
    return this.$el.each(function(i, el) {
      var $child, $el, $link;
      $el = $(el);
      $child = $el.find('ul');
      if ($child[0] != null) {
        $child.css({
          height: '',
          visibility: 'hidden'
        });
        el.childheight = $child.height();
        $child.css({
          height: 0,
          visibility: 'visible'
        });
        el.$child = $child;
      }
      $link = $el.find('>a');
      if ($link[0]) {
        $link.data('container', el);
        $link.on('click', self.handler);
      } else {
        $el.on('click', self.handler);
      }
      return null;
    });
  },
  handler: function(e) {
    var target;
    target = e.currentTarget;
    if ($(target).data('container')) {
      target = $(target).data('container');
    }
    if (target.$child == null) {
      this.closeAll(target);
      this.opened = false;
      return true;
    }
    e.preventDefault();
    this.closeAll(target).done(function() {
      if (target.$child.hasClass('on')) {
        return target.$child.removeClass('on').height(0);
      } else {
        return target.$child.addClass('on').height(target.childheight);
      }
    });
    this.opened = true;
    return null;
  },
  closeAll: function(exclude) {
    var dfd;
    dfd = $.Deferred();
    this.$el.each(function(i, el) {
      var $child;
      $child = $(el).find('ul');
      if (el !== exclude && $child.hasClass('on')) {
        $child.removeClass('on').height(0);
      }
      return null;
    });
    if (this.opened === true) {
      setTimeout(dfd.resolve, this.opt.transitionDuration);
    } else {
      dfd.resolve();
    }
    return dfd.promise();
  }
});

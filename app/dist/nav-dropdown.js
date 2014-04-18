'use strict';
$.GlobalNav = Backbone.View.extend({
  el: 'li',
  events: {
    'click': 'handler'
  },
  initialize: function(options) {
    var lazyUpdate;
    this.opt = {};
    $.extend(this.opt, options);
    _.bindAll(this, 'update', 'handler', 'closeAll');
    setTimeout(this.update, 500);
    lazyUpdate = _.debounce(this.update, 500);
    $(window).on('resize orientationchange', lazyUpdate);
    return null;
  },
  update: function() {
    return this.$el.each(function(i, el) {
      var $el;
      $el = $(el);
      if ($el.find('ul')[0] != null) {
        el.$child = $el.find('ul');
        el.$child.css({
          height: '',
          visibility: 'hidden'
        });
        el.childheight = el.$child.height();
        return el.$child.css({
          height: 0,
          visibility: 'visible'
        });
      }
    });
  },
  handler: function(e) {
    var target;
    target = e.currentTarget;
    e.preventDefault();
    if (target.$child.hasClass('on')) {
      target.$child.removeClass('on').height(0);
    } else {
      target.$child.addClass('on').height(target.childheight);
    }
    this.closeAll(target);
    return null;
  },
  closeAll: function(exclude) {
    this.$el.each(function(i, el) {
      var $child;
      $child = $(el).find('ul');
      if (el !== exclude && $child.hasClass('on')) {
        $child.removeClass('on').height(0);
      }
      return null;
    });
    return null;
  }
});

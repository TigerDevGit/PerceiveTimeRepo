$ = require 'jquery'
util = require '../../util'

# Ripple button behaviour
#
# span.js-ripple-button__ripple is appended to each .js-ripple-button element on page load.
# Clicking on .js-ripple-button positions the .js-ripple-button__ripple element under the cursor
# and adds a class that triggers a CSS animation.
#
# When the animation end event is fired, the class is removed from the .js-ripple-button__ripple.
module.exports = ($el) ->
  $el.find('.js-ripple-button').each ->
    $btn = $ @
    $ripple = $('<span class="js-ripple-button__ripple" />').appendTo $btn
    active = 'js-ripple-button__ripple--active'

    $btn.on 'click', (e) ->
      rect = e.target.getBoundingClientRect()

      $ripple.addClass(active).css({
        top: e.clientY - rect.top
        left: e.clientX - rect.left
      })

    $ripple.on util.animationEndEventName(), -> $ripple.removeClass active

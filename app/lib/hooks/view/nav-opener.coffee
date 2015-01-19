$ = require 'jquery'

# Navigation opening button behaviour
#
# Clicking on .nav-opener toggles 'nav-visible' class on the html element,
# when the html element has this class, main navigation is displayed
# in mobile view.
module.exports = ($el) ->
  $body = $ 'body'
  $main = $ '.main-nav'
  $btn = $el.find '.nav-opener'

  navOpenerClick = (e) ->
    e.stopPropagation()

    opened = $body.toggleClass('nav-visible').is('.nav-visible')

    if opened
      $body.on 'click', navSideClick
      $main.css 'height', window.innerHeight
    else
      $body.off 'click', navSideClick

  navSideClick = (e) ->
    $body.removeClass 'nav-visible'
    $body.off 'click', navSideClick

  $main.on 'click', (e) -> e.stopPropagation()

  $btn.on 'click', navOpenerClick

$ = require 'jquery'

# Navigation opening button behaviour
#
# Clicking on .nav-opener toggles 'nav-visible' class on the html element,
# when the html element has this class, main navigation is displayed
# in mobile view.
module.exports = ($el) ->
  $body = $ 'body'
  $page = $ '.page'
  $main = $ '.main-nav'
  $btn = $el.find '.nav-opener'

  navOpenerClick = (e) ->
    e.stopPropagation()

    opened = $body.toggleClass('nav-visible').is('.nav-visible')

    if opened
      $page.on 'click', navSideClick
      $main.css 'height', window.innerHeight
    else
      $page.off 'click', navSideClick

  navSideClick = (e) ->
    if not $main.get(0).contains e.target
      $body.removeClass 'nav-visible'
      $page.off 'click', navSideClick

  $btn.on 'click', navOpenerClick

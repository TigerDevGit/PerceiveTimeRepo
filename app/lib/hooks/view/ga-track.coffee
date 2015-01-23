$ = require 'jquery'
_ = require 'underscore'

# Lets you track events on click by adding a ga-track tag to the element.
# Should have a comma-delimited list of arguments, e.g.:
#
#   This:  <a href="/signup" ga-track="signup, home_click">
#   Makes: _gaq.push('signup', 'home_click')
module.exports = ($el) ->
  tag = 'ga-track'
  $('[' + tag + ']', $el).on 'click', ->
    return unless window._gaq?

    props = $(@).attr(tag).split(',')
    _gaq.push.apply _gaq, _.invoke(props, 'trim')

$ = require 'jquery'

# Gets the data from all input elements in the form and returns
# an object with their values.
module.exports = ($form) ->
  out = {}
  debugger
  $form.find('input').each ->
    # TODO wouldn't `this.type` and `this.value` cut it? Without JQuery?
    $el = $ this
    # ||= is used here because a `display:none` `input type="password"` was
    # appearing under the login-form. This fixes it, but it'd be nice to know
    # whether this is a problem.
    out[$el.attr('type')] ||= $el.val()
  return out

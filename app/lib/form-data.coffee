$ = require 'jquery'

# Gets the data from all input elements in the form and returns
# an object with their values.
module.exports = ($form) ->
  out = {}
  $form.find('input').each ->
    # TODO wouldn't `this.type` and `this.value` cut it? Without JQuery?
    $el = $ this
    out[$el.attr('type')] = $el.val()
  return out

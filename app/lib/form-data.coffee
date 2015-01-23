$ = require 'jquery'

# Gets the data from all input elements in the form and returns
# an object with their values.
module.exports = ($form) ->
  out = {}
  $form.find('input').each ->
    $el = $ @
    out[$el] = $el.val()


  return out

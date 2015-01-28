# Gets the data from all input elements in the form and returns
# an object with their values.
module.exports = ($form) ->
  out = {}
  $form.find('input').each ->
    if @name
      # ||= is used here because a `display:none` `input type="password"` was
      # appearing under the login-form. This fixes it, but it'd be nice to know
      # whether this is a problem.
      out[@name] ||= @value
  return out

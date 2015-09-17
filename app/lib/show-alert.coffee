sweetAlert = require 'sweetalert'

module.exports = (title, text, type) ->

  # Allow both (attrs) and (title, text, type) parameters
  if typeof title is 'object'
    attrs = title
  else
    attrs = {title, text, type}

  if not /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
    return sweetAlert(attrs)

  # if using native alerts, remove html tags
  if attrs.html? and attrs.text?
    attrs.text = attrs.text.replace(/<[^<]*>/g, '')

  if attrs.type is 'input'
    prompt(attrs.title + " " + attrs.text)
  else
    alert(attrs.title + " " + attrs.text)

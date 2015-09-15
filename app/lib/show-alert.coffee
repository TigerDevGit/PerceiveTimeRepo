sweetAlert = require 'sweetalert'

module.exports = (title, text, type) ->

  # Allow both (attrs) and (title, text, type) parameters
  if typeof title is 'Object'
    attrs = title
  else
    attrs = {title, text, type}

  if not /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
    sweetAlert(attrs)
  else if attrs.type is 'input'
    prompt(attrs.title + " " + attrs.text)
  else
    alert(attrs.title + " " + attrs.text)

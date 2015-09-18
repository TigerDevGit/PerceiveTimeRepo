(->
  sweetAlert = window.sweetAlert or require 'sweetalert'

  usingMac = -> navigator.userAgent.toLowerCase().indexOf('mac')
  usingMobile = -> /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)

  showAlert = (title, text, type) ->
    # Allow both (attrs) and (title, text, type) parameters
    if typeof title is 'object'
      attrs = title
    else
      attrs = {title, text, type}

    # CTRL -> Command key sugar
    if attrs.text? and usingMac()
      attrs.text = attrs.text.replace(/CTRL/g, 'Command')

    if not usingMobile()
      return sweetAlert(attrs)

    # if using native alerts, remove html tags
    if attrs.html? and attrs.text?
      attrs.text = attrs.text.replace(/<[^<]*>/g, '')

    if attrs.type is 'input'
      prompt(attrs.title + " " + attrs.text)
    else
      alert(attrs.title + " " + attrs.text)

  if typeof module is 'object'
    module.exports = showAlert
  else
    window.sweetAlert = showAlert
    showAlert.close = sweetAlert.close
)()

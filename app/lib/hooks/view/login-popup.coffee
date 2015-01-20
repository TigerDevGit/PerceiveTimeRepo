$ = require 'jquery'

module.exports = ($el) ->
  # Require is done here to prevent circular depedency spazz
  Popup = require '../../../views/component/login'

  $('.js-login-button', $el).on 'click', (e) ->
    e.preventDefault()
    new Popup().render()

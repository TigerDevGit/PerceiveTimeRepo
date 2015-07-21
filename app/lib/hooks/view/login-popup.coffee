$ = require 'jquery'

module.exports = (view) ->
  # Require is done here to prevent circular depedency spazz
  LoginPopup = require '../../../views/component/login'

  view.$('.js-login-button').on 'click', (e) ->
    e.preventDefault()
    new LoginPopup().render()

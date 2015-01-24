Modal = require './modal'
formData = require '../../lib/form-data'
API = require '../../lib/api'
$ = require 'jquery'

class LoginPopup extends Modal
  template: 'component/login'

  bindLoginForm: ->
    $error = $ '.login-form__error', @modal
    $form = $ '.login-form', @modal
    $form.on 'submit', (e) ->
      e.preventDefault()
      $error.hide()
      data = formData $form

      new API().auth.session data.username, data.password
        .then ->
          alert 'You\'re logged in! Todo: do something :P'
        .catch ->
          $error.show()

  # Then bind hooks appropriately.
  postRender: ->
    super()
    @bindLoginForm()

    return

module.exports = LoginPopup

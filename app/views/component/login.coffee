Modal = require './modal'
formData = require '../../lib/form-data'
API = require '../../lib/api'
$ = require 'jquery'

class LoginPopup extends Modal
  template: 'component/login'

  bindLoginForm: ->
    $message = $ '.login-form__error', @modal
    $form = $ '.login-form', @modal
    data = null

    startSubmit = (e) ->
      e.preventDefault()
      $message.hide()
      data = formData $form

    $form.on 'submit', (e) ->
      startSubmit e

      new API().auth.session data.username, data.password
        .then ->
          alert 'You\'re logged in! Todo: do something :P'
        .catch ->
          $message.html('Couldn\'t log you in. Please try again!').show()

    $('.js-forgot-password', @modal).on 'click', (e) ->
      startSubmit e

      new API().user.forgot  data.username
        .then ->
          $message.html('An email containing instructions to reset your password has been sent.').show()
        .catch ->
          $message.html('Unknown email, please check that it\'s entered correctly!').show()

  # Then bind hooks appropriately.
  postRender: ->
    super()
    @bindLoginForm()

    return

module.exports = LoginPopup

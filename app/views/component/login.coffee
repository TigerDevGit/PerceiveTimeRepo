Modal = require './modal'
formData = require '../../lib/form-data'
API = require '../../lib/api'
$ = require 'jquery'

class LoginPopup extends Modal
  template: 'component/login'

  submitLogin: (data) ->
    new API('dev', null, null, '/api/v8')
      .auth.session data.email, data.password
      .then ->
        alert 'You\'re logged in! Todo: do something :P'
      .catch (err) ->
        $message.html(
          err?.responseText || 'Couldn\'t log you in. Please try again!'
        ).show()

  forgotPassword: (data) ->
    if not data.email
      @message.html('Please enter an email bellow.').show()
      return

    handleError = (err) =>
      message = switch err.responseText
        when 'E-mail address does not exist\n'
          'Unknown email, please check that it\'s entered correctly!'
        else
          if err.responseText
            err.responseText
          else
            'Failed to trigger a password reset.\n\
            Make sure you\'re connected to the internet'

      @message.html(message).show()

    new API('dev', null, null, '/api/v8')
      .user.forgot  data.email
      .then =>
        @message.html(
          'An email containing instructions to reset your password has been sent.'
        ).show()
      .catch handleError

  startSubmit: (e) =>
    e.preventDefault()
    @message.hide()

  # Then bind hooks appropriately.
  postRender: ->
    super()
    @message = $('.login-form__error', @modal)
    @form = $('.login-form', @modal)

    @form.on 'submit', (e) =>
      @startSubmit e
      @submitLogin(formData @form)

    $('.js-forgot-password', @modal).on 'click', (e) =>
      @startSubmit e
      @forgotPassword(formData @form)

module.exports = LoginPopup

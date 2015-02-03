Modal    = require './modal'
API      = require '../../lib/api'
formData = require '../../lib/form-data'
$        = require 'jquery'


class LoginPopup extends Modal
  template: 'component/login'

  googleLogin: ->
    new API('dev', null, null).user.initGoogleLogin()

  redirectToApp: ->
    document.location = '/app'

  showError: (msg) ->
    @errorMessage.html(msg).show()

  submitLogin: (data) ->
    loginErr = (err) =>
      @showError err?.responseText || 'Couldn\'t log you in. Please try again!'

    new API('dev', null, null)
      .auth.session data.email, data.password
      .then @redirectToApp, loginErr
      .catch loginErr

  forgotPassword: (data) ->
    return @showError 'Please enter an email bellow.' unless data.email

    forgetSuccess = =>
      @showError 'An email containing instructions to reset your password has been sent.'

    handleError = (err) =>
      @showError switch err.responseText
        when 'E-mail address does not exist\n'
          'Unknown email, please check that it\'s entered correctly!'
        else
          if err.responseText
            err.responseText
          else
            'Failed to trigger a password reset.\n\
            Make sure you\'re connected to the internet'

    new API('dev', null, null)
      .user.forgot data.email
      .then forgetSuccess, handleError
      .catch handleError

  startSubmit: (e) =>
    e.preventDefault()
    @errorMessage.hide()

  # Then bind hooks appropriately.
  postRender: ->
    super()
    @errorMessage = @modal.find('.login-form__error')
    @form = @modal.find('.login-form')

    setTimeout =>
      @form.find('input[name=email]').select()

    @form.on 'submit', (e) =>
      @startSubmit e
      @submitLogin(formData @form)

    $('.js-forgot-password', @modal).on 'click', (e) =>
      @startSubmit e
      @forgotPassword(formData @form)

    $('.login-form__oauth__google', @modal).on 'click', (e) =>
      @startSubmit e
      @googleLogin()

module.exports = LoginPopup

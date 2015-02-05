Modal    = require './modal'
API      = require '../../lib/api'
formData = require '../../lib/form-data'
$        = require 'jquery'


class LoginPopup extends Modal
  template: 'component/login'

  googleLogin: ->
    new API('TogglNext', null, null).user.initGoogleLogin()

  redirectToApp: ->
    document.location = '/app'

  showError: (msg) ->
    @errorMessage.html(msg).show()

  submitLogin: (data) ->
    loginErr = (err) =>
      @showError err?.responseText || 'Couldn\'t log you in. Please try again!'

    @updateStatus 'pending'
    new API('TogglNext', null, null)
      .auth.session data.email, data.password
      .then @redirectToApp, loginErr
      .catch loginErr
      .then =>
        @updateStatus 'done'

  updateStatus: (status) ->
    $submitButton = $('.login-form__submit button')
    if $submitButton.timeout
      clearTimeout($submitButton.timeout)

    switch status
      when 'pending'
        onTimeout = ->
          $submitButton.addClass('pending cta-button--no-arrow')
          $submitButton.text('Loading...')
        $submitButton.timeout = setTimeout(onTimeout, 300)
      else
        $submitButton.removeClass('pending cta-button--no-arrow')
        $submitButton.text('Sign-up')

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

    $('.js-forgot-password', @modal).on 'click', =>
      @$el.remove()

    $('.login-form__oauth__google', @modal).on 'click', (e) =>
      @startSubmit e
      @googleLogin()

module.exports = LoginPopup

View     = require '../../view'
API      = require '../../lib/api'
formData = require '../../lib/form-data'
$        = require 'jquery'
jstz     = require('jstimezonedetect').jstz

class SignupView extends View
  template: 'page/signup'
  title: 'Sign Up — Toggl, The Simplest Time Tracker'

  ui:
    submitButton: '.signup-form__submit button'

  events:
    'click .signup-form__oauth': 'googleSignup',
    'submit .signup-form': 'submitSignup',

  initialize: ({params}) ->
    @invitationCode = params[0]
    @api = new API('TogglNext', null, null)

  showError: (msg) =>
    @errorMessage.html(msg).show()

  googleSignup: (e) ->
    e.preventDefault()
    @errorMessage.hide()
    api.user.initGoogleSignup()

  redirectToApp: ->
    document.location = '/app'

  submitSignup: (e) ->
    e.preventDefault()
    @errorMessage.hide()
    @updateStatus 'pending'
    @data = formData $(@$el)
    @data.tz = jstz.determine()?.name()

    signupError = (err) =>
      @showError err?.responseText or 'Failed to sign up.<br />'+
        'Please check your e-mail and password and make sure you\'re online.'

    @api.user.signup @data
      .then @login, signupError
      .catch signupError
      .then =>
        @updateStatus 'done'

  login: =>
    loginError = (err) =>
      @showError err?.responseText or 'Failed to log-in<br />'+
        'Please try using the \'Log in\' button above'

    @api.auth.session @data.email, @data.password
      .then @redirectToApp, loginError
      .catch loginError

  updateStatus: (status) ->
    $submitButton = $(@ui.submitButton)
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

  postRender: ->
    @errorMessage = @$ '.signup-form__error'
    if @invitationCode
      @api.invitation.get @invitationCode
      .then (response) =>
        return unless response
        @$('input[name=email]').val(response).prop 'readonly', true
        @$('input[name=code]').val(@invitationCode)
    else
      setTimeout => @$el.find("[name=email]").select()

module.exports = SignupView

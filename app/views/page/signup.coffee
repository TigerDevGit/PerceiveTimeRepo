View     = require '../../view'
API      = require '../../lib/api'
formData = require '../../lib/form-data'
$        = require 'jquery'
jstz     = require('jstimezonedetect').jstz

class SignupView extends View
  template: 'page/signup'
  title: 'Sign Up — Toggl, The Simplest Time Tracker'

  events:
    'click .signup-form__oauth': 'googleSignup',
    'submit .signup-form': 'submitSignup',

  initialize: ({params}) ->

  showError: (msg) =>
    @errorMessage.html(msg).show()

  googleSignup: (e) ->
    e.preventDefault()
    @errorMessage.hide()
    api = new API('dev', null, null)
    api.user.initGoogleSignup()

  redirectToApp: ->
    document.location = '/app'

  submitSignup: (e) ->
    e.preventDefault()
    @api = new API('dev', null, null)
    @errorMessage.hide()
    @data = formData $(@$el)

    signupError = (err) =>
      @showError err?.responseText || 'Failed to sign up.<br />'+
        'Please check your e-mail and password and make sure you\'re online.'

    @api.user.signup @data.email, @data.password, jstz.determine()?.name()
      .then @login, signupError
      .catch signupError

  login: =>
    loginError = (err) =>
      @showError err?.responseText || 'Failed to log-in<br />'+
        'Please try using the \'Log in\' button above'

    @api.auth.session @data.email, @data.password
      .then @redirectToApp, loginError
      .catch loginError

  postRender: ->
    setTimeout => @$el.find("[name=email]").select()
    @errorMessage = $ '.signup-form__error', @$el

module.exports = SignupView

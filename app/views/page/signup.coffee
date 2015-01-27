View = require '../../view'
formData = require '../../lib/form-data'
API = require '../../lib/api'
$ = require 'jquery'
jstz = require('jstimezonedetect').jstz

class SignupView extends View
  template: 'page/signup'
  title: 'Sign Up — Toggl, The Simplest Time Tracker'

  events:
    'click .signup-form__oauth': 'googleSignup',
    'submit .signup-form': 'submitSignup',

  googleSignup: (e) ->
    e.preventDefault()
    @errorMessage.hide()

    new API('dev', null, null, '/api/v8/').user.initGoogleSignup()

  submitSignup: (e) ->
    e.preventDefault()
    @errorMessage.hide()
    data = formData $(@$el)

    new API('dev', null, null, '/api/v8/')
      .user.signup data.email, data.password, jstz.determine()?.name()
      .then ->
        alert 'You\'re registered! Todo: do something :P'
      .catch (err) =>
        @errorMessage.html(
          err?.responseText ||
          'Failed to sign up.<br />'+
          'Please check your e-mail and password and make sure you\'re online.'
        ).show()

  postRender: ->
    @errorMessage = $ '.signup-form__error', @$el

module.exports = SignupView

View = require '../../view'
formData = require '../../lib/form-data'
API = require '../../lib/api'
$ = require 'jquery'
jstz = require('jstimezonedetect').jstz

class SignupView extends View
  template: 'page/signup'
  title: 'Sign Up — Toggl, The Simplest Time Tracker'

  postRender: ->
    $message = $ '.signup-form__error'
    $('.signup-form', @$el).on 'submit', (e) ->
      e.preventDefault()
      $message.hide()
      data = formData $(this)

      new API('dev', null, null, '/api/v8/')
        .user.signup data.email, data.password, jstz.determine()?.name()
        .then ->
          alert 'You\'re registered! Todo: do something :P'
        .catch (err) ->
          $message.html(
            err?.responseText ||
            'Failed to sign up.<br />'+
            'Please check your e-mail and password and make sure you\'re online.'
          ).show()

module.exports = SignupView

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
      data = formData $(@)

      new API().user.signup data.username, data.password, jstz.determine()?.name()
        .then ->
          alert 'You\'re registered! Todo: do something :P'
        .catch ->
          message = 'Failed to sign up. Please check your e-mail and password and make sure you\'re online.'
          try
            message = jqXHR.responseText
          catch e
            #ignore

          $message.html(message).show()

module.exports = SignupView

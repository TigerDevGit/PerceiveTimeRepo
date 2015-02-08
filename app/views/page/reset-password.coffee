View     = require '../../view'
API      = require '../../lib/api'
formData = require '../../lib/form-data'
$        = require 'jquery'

class SignupView extends View
  template: 'page/reset-password'
  title: 'Reset your password — Toggl, The Simplest Time Tracker'

  initialize: ({@token}) ->
    super
    alert @token

  events:
    'submit': 'resetPassword'

  showError: (msg) =>
    @errorMessage.html(msg).show()

  hideError: =>
    @errorMessage.hide()

  resetSuccess: =>
    @showError 'Your password has now been reset.'

  resetError: (err) =>
    @showError err.responseText || "Failed to reset password. Please make sure you're online."

  loginErr: (err) =>
    @showError err?.responseText || 'Couldn\'t log you in. Please try again manually!'

  loginUser: (email)=>
    data = formData @$el.find 'form'
    new API('dev', null, null)
      .auth.session email, data.password
      .then @redirectToApp, @loginErr
      .catch @loginErr

  redirectToApp: ->
    document.location = '/app'

  resetPassword: (e) =>
    e.preventDefault()
    @hideError()
    data = formData @$el.find 'form'
    match = data.password is data.passwordConfirm
    if not data.password?.length or not match
      @showError 'Passwords do not match'
      return

    $.ajax '/api/v8/confirm_reset_password',
      type: 'POST'
      data: data
      success: @loginUser
      error: @resetError

  showInvalidTokenError: ->
    @showError "Invalid token. Will redirect to index page in 5seconds"
    setTimeout (-> document.location = '/'), 5000

  preRender: ->
    $.ajax
      url: "/api/v8/is_valid_lost_password/#{@token}"
      method: 'GET'
      dataType: 'text'
      success: (@token) =>
        @showInvalidTokenError() if +@token is 0

  postRender: ->
    setTimeout => @$el.find("[name=password]").select()
    @errorMessage = $ '.signup-form__error', @$el
    @$el.find('#reset_code').val @token

module.exports = SignupView

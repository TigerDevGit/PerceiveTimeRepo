View          = require '../../view'
API           = require '../../lib/api'
formData      = require '../../lib/form-data'
redirectToApp = require '../../lib/redirect-to-app'
$             = require 'jquery'
_             = require 'lodash'

class ResetPasswordView extends View
  template: 'page/reset-password'
  title: 'Reset your password — Toggl, The Simplest Time Tracker'

  initialize: ({@token}) -> super

  events:
    submit: 'resetPassword'

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

  loginUser: ({email}) =>
    data = formData @$el.find 'form'
    new API('dev', null, null)
      .auth.session email, data.password
      .then redirectToApp, @loginErr
      .catch @loginErr

  resetPassword: (e) =>
    e.preventDefault()
    @hideError()
    data = formData(@$el.find 'form')
    data.user_id = @user_id
    match = data.password is data.passwordConfirm
    if not data.password?.length or not match
      @showError 'Passwords do not match'
      return

    $.ajax '/api/v9/me/lost_passwords/confirm',
      type: 'POST'
      data: JSON.stringify data
      contentType: "application/json"
      dataType: "json"
      success: @loginUser
      error: @resetError

  showInvalidTokenError: =>
    @showError "Invalid token. Will redirect to index page in 5 seconds"
    setTimeout (-> document.location = '/'), 5000

  preRender: ->
    $.ajax
      url: "/api/v9/me/lost_passwords/#{@token}"
      method: 'GET'
      success: ({@user_id}) =>
      error: @showInvalidTokenError

  postRender: ->
    setTimeout => @$el.find("[name=password]").select()
    @errorMessage = $ '.signup-form__error', @$el
    @$el.find('#reset_code').val @token

module.exports = ResetPasswordView

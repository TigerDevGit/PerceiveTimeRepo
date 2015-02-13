Modal              = require './modal'
API                = require '../../lib/api'
formData           = require '../../lib/form-data'
pendingButtonMixin = require '../../lib/mixins/pending-button-mixin'
$                  = require 'jquery'
_                  = require 'underscore'

class LoginPopup extends Modal
  template: 'component/login'

  googleLogin: ->
    form = formData @form
    new API('TogglNext', null, null).user.initGoogleLogin(form.remember_me)

  redirectToApp: ->
    document.location = '/app'

  showError: (msg) ->
    @errorMessage.html(msg).show()

  submitLogin: (data) ->
    loginErr = (err) =>
      @showError err?.responseText || 'Couldn\'t log you in. Please try again!'

    return if @isPending()
    @updateStatus 'pending'

    new API('TogglNext', null, null)
      .auth.session data.email, data.password, data.remember_me
      .then @redirectToApp, loginErr
      .catch loginErr
      .then(
        (=> @updateStatus 'done'),
        (=> @updateStatus 'done')
      )

  startSubmit: (e) =>
    e.preventDefault()
    @errorMessage.hide()

  # Then bind hooks appropriately.
  postRender: ->
    super()
    @errorMessage = @modal.find('.login-form__error')
    @form = @modal.find('.login-form')
    @submitButton = @modal.find('.login-form__submit button')

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

    # If the router navigates away from the current route destroy the modal
    # This fixes history after navigating to `/login`.
    router = require('../../toggl').router
    @listenTo router, 'route', (r) => if r != 'showLogin' then @trigger 'teardown'

_.extend(LoginPopup.prototype, pendingButtonMixin)

module.exports = LoginPopup

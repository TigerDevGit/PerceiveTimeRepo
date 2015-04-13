Modal              = require './modal'
API                = require '../../lib/api'
formData           = require '../../lib/form-data'
pendingButtonMixin = require '../../lib/mixins/pending-button-mixin'
$                  = require 'jquery'
_                  = require 'lodash'

class LoginPopup extends Modal
  template: 'component/login'

  initialize: (options) ->
    @returnTo = options?.returnTo
    super

  googleLogin: ->
    form = formData @form
    new API('TogglNext', null, null).user.initGoogleLogin(form.remember_me)

  redirectToApp: =>
    document.location = @returnTo or '/app'

  showError: (msg) ->
    @errorMessage.html(msg).show() unless @announcementMessage.is(':visible')

  submitLogin: (data) ->
    loginErr = (err) =>
      @showError err?.responseText || 'Couldn\'t log you in. Please try again!'

    return if @isPending()
    @updateStatus 'pending'

    # Stop listening to model changes so the login form isn't rerendered before
    # the redirect.
    @stopListening(@model, 'change')

    new API('TogglNext', null, null)
      .auth.session data.email, data.password, data.remember_me
      .then @redirectToApp, loginErr
      .catch loginErr
      .then(
        (=> @updateStatus 'done'),
        (=>
          @listenTo(@model, 'change', @render)
          @updateStatus 'done')
      )

  startSubmit: (e) =>
    e.preventDefault()
    @errorMessage.hide()

  showAnnouncement: ->
    @siteOptionsModel = require('../../lib/site-options-model')()
    @listenTo @siteOptionsModel, 'change', @renderAccouncement
    @renderAccouncement()

  renderAccouncement: ->
    return if not @siteOptionsModel.get('loginForm')
    onOff = !!@siteOptionsModel.get('loginForm').showAnnouncement
    @errorMessage.hide() if onOff
    @announcementMessage.toggle onOff
    @announcementMessage.html @siteOptionsModel.get('loginForm').announcement

  # Then bind hooks appropriately.
  postRender: ->
    super()
    @errorMessage = @modal.find('.login-form__error.default')
    @announcementMessage = @modal.find('.login-form__error.announcement')
    @form = @modal.find('.login-form')
    @submitButton = @modal.find('.login-form__submit button')

    setTimeout =>
      @form.find('input[name=email]').select()

    @form.on 'submit', (e) =>
      @startSubmit e
      @submitLogin(formData @form)

    $('.js-forgot-password', @modal).on 'click', =>
      @remove()

    $('.login-form__oauth__google', @modal).on 'click', (e) =>
      @startSubmit e
      @googleLogin()

    # If the router navigates away from the current route destroy the modal
    # This fixes history after navigating to `/login`.
    router = require('../../toggl').router
    @listenTo router, 'route', (r) => if r != 'showLogin' then @trigger 'teardown'

    @showAnnouncement()

_.extend(LoginPopup.prototype, pendingButtonMixin)

module.exports = LoginPopup

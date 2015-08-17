View               = require '../../view'
API                = require '../../lib/api'
formData           = require '../../lib/form-data'
pendingButtonMixin = require '../../lib/mixins/pending-button-mixin'
$                  = require 'jquery'
jstz               = require('jstimezonedetect').jstz
_                  = require 'lodash'

class SignupView extends View
  template: 'page/signup'
  title: 'Toggl - Sign up, Track Time & Analyze Profitability'
  meta: [
    name: 'description'
    content: 'Track project hours or general time usage. Analyze business profitability, personal productivity or keep track of employee timesheets.'
  ]

  events:
    'click .signup-form__oauth': 'googleSignup',
    'submit .signup-form': 'submitSignup',

  attributes:
    title: 'Get Started Now!'
    caption: ''
    showOAuth: true
    buttonLabel: 'Sign up for free'

  initialize: ({@invitationCode}) ->
    super
    @api = new API('TogglNext', null, null)
    if @invitationCode
      $(document.body).addClass('body--white')
      @attributes = {
        title: 'Welcome to Toggl!'
        caption: 'Take charge of your time. Track down your hours and learn to work smarter, not harder.'
        isInvitation: true
        showOAuth: false
        hideNav: true
        buttonLabel: "Join the team"
      }

  onRemove: ->
    $(document.body).removeClass('body--white')

  showError: (msg) =>
    @errorMessage.html(msg).show()

  googleSignup: (e) ->
    e.preventDefault()
    @errorMessage.hide()
    @api.user.initGoogleSignup()

  submitSignup: (e) ->
    e.preventDefault()

    return if @isPending()
    @updateStatus 'pending'

    @errorMessage.hide()
    @data = formData $(@$el)
    @data.timezone = jstz.determine()?.name()

    signupError = (err) =>
      @showError err?.responseText or 'Failed to sign up.<br />'+
        'Please check your e-mail and password and make sure you\'re online.'

    @api.user.signup @data
      .then @login, signupError
      .catch signupError
      .then(
        (=> @updateStatus 'done'),
        (=> @updateStatus 'done')
      )

  login: =>
    loginSuccess = =>
      @trigger 'login:success'

    loginError = (err) =>
      @showError err?.responseText or 'Failed to log-in<br />'+
        'Please try using the \'Log in\' button above'

    @api.auth.session @data.email, @data.password
      .then loginSuccess, loginError
      .catch loginError


  postRender: ->
    @errorMessage = @$ '.signup-form__error'
    @submitButton = @$ '.signup-form__submit button'
    if @invitationCode
      @api.invitation.get(@invitationCode)
        .then (invite) =>
          return unless invite
          @$('input[name=email]').val(invite.email).prop('readonly', true)
          @$('input[name=code]').val(@invitationCode)
          name = invite.sender_name?.split(' ')[0]
          if name and name.length < 9
            @submitButton.text("Join #{name}'s Team")
        .catch (err) =>
          @showError(
            err?.responseText or 'Failed to validate your invitation code<br />
              Please try reloading the page'
          )
    else
      setTimeout => @$el.find("[name=email]").select()

_.extend(SignupView.prototype, pendingButtonMixin)

module.exports = SignupView

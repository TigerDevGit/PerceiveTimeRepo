showAlert        = require '../../lib/show-alert'
jstimezonedetect = require 'jstimezonedetect'
View             = require '../../view'
Api              = require '../../lib/api'
redirectToApp    = require '../../lib/redirect-to-app'
parseQuery       = require '../../lib/parse-query'
utils            = require '../../lib/utils'

jstz = jstimezonedetect.jstz

class IndexView extends View
  template: 'page/index'
  hooks: ['frontvideo', 'timer']
  title: 'Toggl - Free Time Tracking Software & App'
  meta: [
    name: 'description'
    content: 'Get better at time management, increase small business revenues or easily manage employee timesheets. Best cloud based multi-platform timer.'
  ]

  onShow: ->
    # Inject video onto the page
    html = @_videoHtml()
    @$('.video .wrapper').html(html)
    @$('.video .wrapper iframe').load => @trigger('video:load')

  _videoHtml: ->
    id = if @attributes.isAprilFoold
      123713375
    else 120347656

    return "<iframe src=\"https://player.vimeo.com/video/#{id}?api=1&autoplay=0&loop=1&color=ffffff&title=0&byline=0&portrait=0\"\
                    frameborder=\"0\"\
                    webkitallowfullscreen\
                    mozallowfullscreen\
                    allowfullscreen>\
            </iframe>"

  events:
    'click .js-redirect-to-app': (e) ->
      return unless @model.get('logged')
      e.preventDefault()
      redirectToApp()

  isAprilFools: ->
    d = new Date()
    d.getMonth() is 3 and d.getDate() <= 8

  initialize: ->
    @on('show', => @onShow())
    super
    @attributes =
      videoDisabled: 'ontouchstart' of document.body
      aprilFools: @isAprilFools()
      navLight: true

    query = parseQuery(window.location.search)

    if not query.code
      return

    api = new Api('TogglNext', null, null, '/api/v8')

    if query.state == 'profile'
      document.location = "/app/profile/#{query.code}"
      return
    else if query.state == 'signup'
      return api
        .user.completeGoogleSignup(query.code, jstz.determine()?.name())
        .then (response) =>
          if response.has_account
            redirectToApp()
          else
            api.auth.session response.data.api_token, 'api_token'
        .then redirectToApp
        .catch (err) ->
          reason = err?.responseText

          if reason?.match(/^OAuthError/)
            # responseTexts coming from OAuth are weird. err.responseText
            # could be: (yes, all that is the err.responseText)
            #
            # ```
            # OAuthError: updateToken: 400 Bad Request {"error" :
            # "invalid_grant","error_description" : "Code was already
            # redeemed.”}
            # ```
            #
            # so we extract the json object and we get a nicer error
            # description/reason
            #
            json = reason.match(/{[\s\S]*}/)?[0]
            if json?
              err = JSON.parse json
              reason = err.error_description

          else if reason is "User with this email already exists\n"
            googleSignInURL = 'http://support.toggl.com/google-sign-in/'
            reason = reason.slice(0, -1) # remove new line
            reason += " and it has 'Google Sign In' disabled.\n\nMore info: \
              #{ utils.generateLink(googleSignInURL, 'external') }."

          reason ?= utils.genericErrorMessage
          showAlert
            title: "Signup failed."
            text: reason
            html: true

    else if query.state in ['login', 'login_remember']
      remember = query.state is 'login_remember'
      api
        .user.completeGoogleLogin query.code, remember
        .then redirectToApp
        .catch (err) ->
          if err.status is 403
            showAlert "Failed to login with Google.", "Are you sure this is the right account?", 'error'
          else
            showAlert
              title: "Failed to login with Google."
              text: err?.responseText or utils.genericErrorMessage
              type: 'error'
              html: true

module.exports = IndexView

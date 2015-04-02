jstimezonedetect = require 'jstimezonedetect'
Api = require '../../lib/api'
parseQuery = require '../../lib/parse-query'
View = require '../../view'

jstz = jstimezonedetect.jstz

class IndexView extends View
  template: 'page/index'
  hooks: ['frontvideo', 'timer']
  title: 'Toggl - Free Time Tracking Software'

  isAprilFools: ->
    d = new Date()
    d.getMonth() is 3 and d.getDate() <= 8

  initialize: ->
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
        .then (response) ->
          api.auth.session response.data.api_token, 'api_token'
        .then ->
          document.location = '/app'
        .catch (err) ->
          unless err?.responseText.indexOf("already redeemed") != -1 # Hide error caused by browser refresh
            alert "Signup failed. " + err?.responseText
    else if query.state in ['login', 'login_remember']
      remember = query.state is 'login_remember'
      api
        .user.completeGoogleLogin query.code, remember
        .then ->
          document.location = '/app'
        .catch (err) ->
          if err.status is 403
            alert "Failed to login with Google, are you sure this is the right account?"
          else
            alert "Failed to login with Google. " + err?.responseText

module.exports = IndexView

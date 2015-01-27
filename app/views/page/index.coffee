jstimezonedetect = require 'jstimezonedetect'
Api = require '../../lib/api'
parseQuery = require '../../lib/parse-query'
View = require '../../view'

jstz = jstimezonedetect.jstz

class IndexView extends View
  template: 'page/index'
  hooks: ['frontvideo', 'timer']
  title: 'Toggl - Free Time Tracking Software'

  initialize: ->
    @attributes =
      navLight: true

    query = parseQuery(window.location.search)

    if not query.code
      return

    if query.state == 'signup'
      return new Api('dev', null, null, '/api/v8')
        .user.completeGoogleSignup(query.code, jstz.determine()?.name())

    new Api('dev', null, null, '/api/v8')
      .auth.session query.code, 'oauth_code', query.state == 'remember_me'
      .then ->
        alert 'Signed-in'
      .catch (err) ->
        alert 'Failed with: ' + err && err.responseText

module.exports = IndexView

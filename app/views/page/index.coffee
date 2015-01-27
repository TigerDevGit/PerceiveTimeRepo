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

    code = @getCode()
    if code?


      new Api('dev', null, null, '/api/v8')
        .user.completeGoogleSignup(code, jstz.determine()?.name())

    return

  getCode: ->
    q = parseQuery(window.location.search.slice(1))
    q?.code

module.exports = IndexView

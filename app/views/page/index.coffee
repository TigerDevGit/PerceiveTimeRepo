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
    super
    @attributes =
      navLight: true

    query = parseQuery(window.location.search)

    if not query.code
      return

    api = new Api('dev', null, null, '/api/v8')
    if query.state == 'signup'
      return api
        .user.completeGoogleSignup(query.code, jstz.determine()?.name())
        # Ignore the error and just authenticate with Google, if the account is
        # already associated
        # TODO Tell the user about doing this
        #
        # This isn't working properly yet.
        #.catch (err) ->
          #alreadyAssociatedErr = 'Your Google account is already associated
                                  #with another Toggl account.\n'
          #if(err && err.responseText == alreadyAssociatedErr)
            #return
          #else
            #alert 'Failed with: ' + err && err.responseText
            #throw err
        .then ->
          api.user.completeGoogleLogin query.code
        .then ->
          document.location = '/app'
        # TODO Factor out `signup -> login -> redirect` logic and remove
        # duplication; see the `signup` view
        .catch (err) ->
          alert 'Failed with: ' + err && err.responseText

    api
      .user.completeGoogleLogin query.code, query.state == 'remember_me'
      .then ->
        document.location = '/app'
      .catch (err) ->
        alert 'Failed with: ' + err && err.responseText

module.exports = IndexView

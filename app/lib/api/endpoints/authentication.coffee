module.exports = (api) ->
  return {
    # Sets the API's username and password up. Hits /me so it's
    # the same as session-based auth.
    basic: (username, password) ->
      return api
        .setAuth username, password
        .request 'get', 'me'

    # Attempts a cookie-based authentication for the session.
    session: (username, password, remember = false) ->
      return api
        .setAuth username, password
        .request 'post', 'sessions', { data: { remember_me: remember }}
        .then (args...) ->
          # on successful responses we no longer need auth data,
          # so remove it from the API
          api.auth = null

          return Bluebird.resolve args...

    # Clears a cookie-based session
    destroy: ->
      return api.request 'delete', 'sessions'
  }

Base64 = require 'Base64'

module.exports = (api) ->
  return {
    # Creates a new user with the email, password, and timezone.
    signup: (email, password, tz) ->
      return api.request 'post', 'signups',
        processData: false
        contentType: 'application/json'
        data: JSON.stringify(
          user:
            email: email
            password: password
            timezone: tz
            created_with: api.name
        )

    # Forgot a password functionality. Causes an email to be sent
    # to the user with reset instructions.
    forgot: (email) ->
      return api.request 'post', 'lost_passwords',
        processData: false
        contentType: 'application/json'
        data: JSON.stringify(
          email: email
        )

    # Creates an user with Google OAuth. This will trigger a redirect to an
    # OAuth page, which redirect back to the app on success, and should be
    # handled with `completeGoogleSignup`.
    initGoogleSignup: ->
      api
        .request 'get', 'oauth_url?state=signup',
          dataType: undefined # The response isn't JSON; see SO question 6186770
        .then (result) ->
          document.location = result

    # Completes an OAuth Sign-up given a token (which should be available on
    # redirect).
    completeGoogleSignup: (code, tz) ->
      api
        .request 'post', 'signups',
          contentType: 'application/json'
          dataType: undefined
          data: JSON.stringify(
            code: code
            user:
              timezone: tz
              created_with: api.name
          )
          beforeSend: (xhr) ->
            authHeader = "Basic #{Base64.btoa(code + ':api_token')}"
            xhr.setRequestHeader 'Authorization', authHeader
        .then ->
          alert 'You\'re registered! Todo: do something :P'
        .catch (err) ->
          # TODO Error handling should be done by the callee (IndexView).
          alert 'Failed with: ' + err.responseText
  }

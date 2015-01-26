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
        data:
          email: email
  }

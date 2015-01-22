module.exports = (api) ->
  return {
    # Creates a new user with the email, password, and timezone.
    signup: (email, password, tz) ->
      return @request 'post', 'signups',
        data:
          email: email
          password: password
          timezone: timezone
          created_with: api.name
  }

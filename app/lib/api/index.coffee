require('es6-promise').polyfill()
Base64 = require 'Base64'
$ = require 'jquery'
_ = require 'underscore'
endpoints = require './endpoints'

class TogglApi
  # Toggl API constructor. "Name" is required in several endpoints.
  # Username (or API token) and password (not necessary if using token)
  # can be passed here, or you can call auth.basic later.
  constructor: (name, username, password,
                endpoint = 'https://www.toggl.com/api/v8') ->
    @endpoint = endpoint
    @name = name
    @auth = null

    if !!username
      @setAuth username, password

    # attach endpoints to the api instance
    for key, module of endpoints
      @[key] = module this

  # Sets the authentication username (or API token) and password, if not
  # using the token, of the toggl API.
  setAuth: (username, password = 'api_token') ->
    @username = username
    @password = password
    return this

  # Constructs a new URL to the API endpoint, where `path` is relative.
  url: (path) ->
    # Don't do anything if the URL is already full.
    if path.slice(0, 4) is 'http'
      return path

    # Removing trailing slash from the endpoint and preceeding slash
    # from the path.
    if @endpoint.slice(-1) is '/'
      @endpoint = @endpoint.slice 0, -1
    if path.slice(0, 1) is '/'
      path = path.slice 1

    return [ @endpoint, path ].join '/'

  # Runs a request to the endpoint. Adds in authentication data if set.
  request: (method, path, options = {}) ->
    url = @url path

    # If we have auth settings, add the `Authorization` header
    if @username and @password
      {username, password} = this
      originalBeforeSend = options.beforeSend
      options.beforeSend = (xhr) ->
        authHeader = "Basic #{Base64.btoa(username + ':' + password)}"
        xhr.setRequestHeader 'Authorization', authHeader
        originalBeforeSend(xhr) if originalBeforeSend

    # Create a new promise for a jquery xhr
    return new Promise (resolve, reject) ->
      $.ajax _.extend({
        type: method.toUpperCase()
        dataType: 'json'
        url: url
        success: resolve
        error: reject
      }, options)

module.exports = TogglApi

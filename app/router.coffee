Backbone = require 'backbone'
$        = require 'jquery'
_        = require 'underscore'

currentView = null
renderPage = (Page, paramsObj) ->
  $(window).scrollTop 0
  currentView?.trigger 'destroy'
  currentView = new Page(paramsObj).render()

# Create a new backbone router with the routes specified
Router = class Router extends Backbone.Router
  initialize: ->
    @on 'all', =>
      $(document.body).attr id: Backbone.history.fragment
      # Track the pageviews with the new universal tracker
      ga? 'send', 'pageview', @_getCurrentRoute()

  routes:
    '': -> renderPage require './views/page/index'
    'features': -> renderPage require './views/page/features'
    'about': -> renderPage require './views/page/about'
    'landing': -> renderPage require './views/page/landing'
    'tools': -> renderPage require './views/page/tools'
    'legal/privacy': -> renderPage require './views/page/privacy'
    'legal/terms': -> renderPage require './views/page/terms'
    'forgot-password': -> renderPage require './views/page/forgot-password'
    'reset_password/:token': 'showResetPassword'
    'signup(/:invitationCode)': 'showSigup'

  showResetPassword: (token) ->
    ResetPassword = require './views/page/reset-password'
    renderPage ResetPassword, { token }

  showSignup: (inivitationCode) ->
    Signup = require './views/page/signup'
    renderPage Signup, { inivitationCode }

  # Returns the current route
  # If the route is a regexp then it will return the regexp
  _getCurrentRoute: =>
    fragment = Backbone.history.fragment
    routes   = _.keys @routes
    _.find routes, (handler) =>
      route = if _.isRegExp(handler) then handler else @_routeToRegExp(handler)
      route.test fragment

module.exports = Router

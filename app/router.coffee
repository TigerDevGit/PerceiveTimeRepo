Backbone = require 'backbone'
$        = require 'jquery'
_        = require 'lodash'

currentView = null
renderPage = (Page, paramsObj) ->
  $(window).scrollTop 0
  currentView?.trigger 'destroy'
  currentView = new Page(paramsObj).render()

# Create a new backbone router with the routes specified
Router = class Router extends Backbone.Router

  initialize: ->
    @on 'route', =>
      $(document.body).attr id: Backbone.history.fragment
      # Track the pageviews with the new universal tracker
      ga? 'send', 'pageview', @_getCurrentRoute()

  routes: ->
    _.extend {
      '(/)': -> renderPage require './views/page/index'
      'features(/)': -> renderPage require './views/page/features'
      'about(/)': -> renderPage require './views/page/about'
      'tools(/)': -> renderPage require './views/page/tools'
      'legal/privacy(/)': -> renderPage require './views/page/privacy'
      'legal/terms(/)': -> renderPage require './views/page/terms'
      'forgot-password(/)': -> renderPage require './views/page/forgot-password'
      'unsubscribe/:type/:token(/)': 'showUnsubscribe'
      'reset_password/:token': 'showResetPassword'
      'signup(/:invitationCode)': 'showSignup'
      'login(/)': 'showLogin'
    }, _.mapValues require('./landing-routes'), (params) ->
      -> renderPage require('./views/page/landing'), params

  showUnsubscribe: (type, token) ->
    Unsubscribe = require './views/page/unsubscribe'
    renderPage Unsubscribe, { token, type }

  showResetPassword: (token) ->
    ResetPassword = require './views/page/reset-password'
    renderPage ResetPassword, { token }

  showSignup: (invitationCode) ->
    Signup = require './views/page/signup'
    renderPage Signup, { invitationCode }

  showLogin: (qs) ->
    query = if qs
      _.reduce(qs.split('&'), (memo, c) ->
        [key, value] = c.split('=')
        memo[key and decodeURIComponent(key)] =
          value and decodeURIComponent(value)
        memo
      , {})
    else {}
    indexView = renderPage require './views/page/index'

    renderLogin = ->
      LoginPopup = require './views/component/login'
      new LoginPopup(returnTo: query.return_to).render()

    # Wait until the indexView's model 'change' event gets triggered (which
    # relies on an /api/v9/me/logged request to be emitted). If it's not
    # pending, just render (it won't be pending if a user goes from '/login' to
    # another page then back in history - then `change` would never be emitted)
    if indexView.model.get 'pending'
      indexView.model.on 'change', renderLogin
    else renderLogin()

  # Returns the current route
  # If the route is a regexp then it will return the regexp
  _getCurrentRoute: =>
    fragment = Backbone.history.fragment
    routes   = _.keys @routes
    _.find routes, (handler) =>
      route = if _.isRegExp(handler) then handler else @_routeToRegExp(handler)
      route.test fragment

module.exports = Router

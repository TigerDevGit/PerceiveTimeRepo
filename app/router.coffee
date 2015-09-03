Backbone   = require 'backbone'
$          = require 'jquery'
_          = require 'lodash'
parseQuery = require './lib/parse-query'

$application = $('.application')
currentView = null
renderPage = (Page, paramsObj) ->
  $(window).scrollTop 0
  currentView?.remove()
  currentView = new Page(paramsObj).render()
  $application.html(currentView.$el)
  currentView.trigger('show')
  currentView

# Create a new backbone router with the routes specified
Router = class Router extends Backbone.Router

  initialize: ->
    @on 'route', ->
      $(document.body).attr id: Backbone.history.fragment

  routes: ->
    _.extend {
      '(/)': -> renderPage require './views/page/index'
      'features(/)': -> renderPage require './views/page/features'
      'about(/)': -> renderPage require './views/page/about'
      'tools(/)': -> renderPage require './views/page/tools'
      'legal/privacy(/)': 'showPrivacy'
      'legal/terms(/)': 'showTos'
      'forgot-password(/)': -> renderPage require './views/page/forgot-password'
      'unsubscribe/:type/:token(/)': 'showUnsubscribe'
      'reset_password/:token': 'showResetPassword'
      'signup(/:invitationCode)': 'showSignup'
      'login(/)': 'showLogin'
      'pricing(/)': 'showPricing'
      'business(/)': -> window.location = '/business' # hack to redirect to static page
    }, _.mapValues require('./landing-routes'), (params) ->
      -> renderPage require('./views/page/landing'), params

  showUnsubscribe: (type, token) ->
    Unsubscribe = require './views/page/unsubscribe'
    renderPage Unsubscribe, { token, type }

  showResetPassword: (token) ->
    ResetPassword = require './views/page/reset-password'
    renderPage ResetPassword, { token }

  showPricing: ->
    Pricing = require './views/page/pricing'
    renderPage Pricing

  showSignup: (invitationCode) ->
    Signup = require './views/page/signup'
    renderPage Signup, { invitationCode }

  showTos: (qs) ->
    { simple } = parseQuery(qs)
    TermsPage = require './views/page/terms'
    renderPage TermsPage, { simple }

  showPrivacy: (qs) ->
    { simple } = parseQuery qs
    PrivacyPage = require './views/page/privacy'
    renderPage PrivacyPage, { simple }

  showLogin: (qs) ->
    query = parseQuery(qs)
    indexView = renderPage require './views/page/index'

    renderLogin = ->
      LoginPopup = require './views/component/login'
      new LoginPopup(returnTo: query.return_to, expired: query.expired).render()

    # Wait until the indexView's model 'change' event gets triggered (which
    # relies on an /api/v9/me/logged request to be emitted). If it's not
    # pending, just render (it won't be pending if a user goes from '/login' to
    # another page then back in history - then `change` would never be emitted)
    if indexView.model.get 'pending'
      @listenToOnce indexView.model, 'change', renderLogin
    else renderLogin()

module.exports = Router

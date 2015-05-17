Backbone = require 'backbone'
Bugsnag  = require 'bugsnag-js'
$        = require 'jquery'
_        = require 'lodash'

# Set-up Bugsnag
environment = do ->
  host = document.location.host
  if _.startsWith(host, 'next.toggl.com') or
     _.startsWith(host, 'fubar.toggl.com')
    "staging"
  else if _.startsWith(host, 'www.toggl.com') or
          _.startsWith(host, 'toggl.com') or
          _.startsWith(host, 'new.toggl.com')
    "production"
  else "development"

# Log so that end-users can report the website's version they are using
version = $('body').data('version')
console.log "With <3 by Toggl. v#{version} (website)"

Bugsnag.apiKey = 'bc2e8b6278a6e7b3d6345fe6a373b120'
Bugsnag.releaseStage = environment
Bugsnag.notifyReleaseStages = ['development', 'staging', 'production']
Bugsnag.appVersion = version

# Fix required when using backbone with Browserify:
Backbone.$ = $

# Start the router
Router = require './router'
router = exports.router = new Router
Backbone.history.start { pushState: true }

# Also listen for link clicks in the page for links that begin with
# a slash, for internal navigation.
$(document).on 'click', 'a[href^="/"]', (e) ->
  return if this.attributes.clickthrough
  href = this.attributes.href.value

  # Clear the anchor
  window.location.hash = ''
  if history.pushState
    history.pushState('', document.title, window.location.pathname)

  res  = Backbone.history.navigate href, { trigger: true }
  return if href.indexOf('#') > -1
  # If there was no history navigation action then force load the URL
  Backbone.history.loadUrl href unless res
  return false

# Add global hooks
require('./lib/hooks/global/stretch')()
require('./lib/hooks/global/hiring')()

# Notify prerender io that the page is ready to be served
window.prerenderReady = true

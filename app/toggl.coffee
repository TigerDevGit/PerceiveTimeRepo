Backbone = require 'backbone'
$        = require 'jquery'
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

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
  e.preventDefault()
  href = this.attributes.href.value
  res  = Backbone.history.navigate href, { trigger: true }
  # If there was no history navigation action then navigate it through the router again
  # only this time remove the hash
  Backbone.history.loadUrl href.split('#')[0] unless res
  return false

# Add global hooks
require('./lib/hooks/global/stretch')()

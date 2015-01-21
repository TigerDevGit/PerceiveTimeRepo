Backbone = require 'backbone'
$ = require 'jquery'
# Fix required when using backbone with Browserify:
Backbone.$ = $

# Start the router
router = require './router'
Backbone.history.start { pushState: true }

# Also listen for link clicks in the page for links that begin with
# a slash, for internal navigation.
$(document).on 'click', 'a[href^="/"]', (e) ->
  e.preventDefault()
  Backbone.history.navigate this.attributes.href.value, { trigger: true }
  return false

# Add global hooks
require('./lib/hooks/global/stretch')()

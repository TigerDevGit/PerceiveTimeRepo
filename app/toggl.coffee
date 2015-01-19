Backbone = require 'backbone'
$ = require 'jquery'
Backbone = require 'Backbone'
# Fix required when using backbone with Browserify:
Backbone.$ = $

# Start the router
router = require './router'
Backbone.history.start()

# Add global hooks
require('./lib/hooks/global/stretch')()

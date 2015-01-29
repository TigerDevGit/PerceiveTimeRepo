$ = require 'jquery'
Backbone = require 'backbone'
Backbone.$ = $

# Import the precompiled templates
Handlebars = require 'handlebars'
templates = require('./templates/compiled')(Handlebars)

# Get the view "hooks"
hooks = require './lib/hooks'

# This serves as a basis for our other views, doing the "heavy lifting" of
# templating behind the scenes for us.
class View extends Backbone.View
  el: '.page'
  render: ->
    # Prerender actions
    @preRender?()

    # Inject the compiled page
    @$el.html templates[@template](@attributes)

    # Update document title.
    if @title?
      document.title = @title

    # Attach hooks
    @bindHooks()

    # Postrender if necessary
    @postRender?()

    return this

  bindHooks: ->
    # Run view cooks
    hook(@$el, this) for hook in hooks.view
    # Run page hooks
    hooks.page[hook](@$el, this) for hook in @hooks if @hooks?

module.exports = View

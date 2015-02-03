$ = require 'jquery'
Backbone = require 'backbone'
Backbone.$ = $
_ = require 'underscore'

# Import the precompiled templates
Handlebars = require 'handlebars'
templates = require('./templates/compiled')(Handlebars)

# Get the view "hooks"
hooks = require './lib/hooks'

# This serves as a basis for our other views, doing the "heavy lifting" of
# templating behind the scenes for us.
class View extends Backbone.View
  el: '.page'
  model: require './lib/user-state-model'
  initialize: ->
    @listenTo @model, 'change', @render

  render: ->
    @preRender?()
    data = _.extend @model.toJSON(), @attributes
    @$el.html templates[@template] data
    document.title = @title if @title?
    @bindHooks()
    @postRender?()
    return this

  bindHooks: ->
    # Run view cooks
    hook(@$el, this) for hook in hooks.view
    # Run page hooks
    hooks.page[hook](@$el, this) for hook in @hooks if @hooks?

module.exports = View

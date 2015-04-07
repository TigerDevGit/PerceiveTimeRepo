$ = require 'jquery'
Backbone = require 'backbone'
Backbone.$ = $
_ = require 'lodash'

# Import the precompiled templates
Handlebars = require 'handlebars'
templates = require('./templates')(Handlebars)

# Get the view "hooks"
hooks = require './lib/hooks'

DEFAULT_META_TAGS = [{
  name: 'Description'
  content: 'Toggl is an online time tracking tool. It features 1-click time tracking and helps you see where your time goes. Free and paid versions are available.'
}, {
  name: 'Keywords'
  content: 'time tracking, time tracking tool, online time tracking, free time tracking, 1-click time tracking, productivity tools, time tracker, timetracker, time tracker software, timetracking'
}]

# This serves as a basis for our other views, doing the "heavy lifting" of
# templating behind the scenes for us.
class View extends Backbone.View
  el: '.page'
  model: require './lib/user-state-model'

  initialize: ->
    @meta ?= DEFAULT_META_TAGS
    @listenTo @model, 'change', @render

  render: ->
    @.trigger 'pre-render'
    @preRender?()
    data = _.extend @model.toJSON(), @attributes
    @changeMetaTags()
    @$el.html templates[@template] data
    document.title = @title if @title?
    @bindHooks()
    @postRender?()
    @scrollToAnchor()
    return this

  changeMetaTags: ->
    CUSTOM_META_CLASS = 'custom-meta-tag'
    # Remove all old custom meta tags
    $(".#{CUSTOM_META_CLASS}").remove()
    for metaOpts in @meta
      tag = $ '<meta/>', _.extend metaOpts, class: CUSTOM_META_CLASS
      $('head').append tag

  scrollToAnchor: ->
    hash = location.hash
    return unless hash
    $hash = $(hash)
    return unless $hash.length
    position = $hash.offset().top
    $(document.body).scrollTop position

  bindHooks: ->
    # Run view cooks
    hook(@$el, this) for hook in hooks.view
    # Run page hooks
    hooks.page[hook](@$el, this) for hook in @hooks if @hooks?

module.exports = View

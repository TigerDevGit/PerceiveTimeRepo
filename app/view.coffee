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
  content: 'Toggl is an online time tracking tool. It features 1-click time
            tracking and helps you see where your time goes. Free and paid
            versions are available.'
}, {
  name: 'Keywords'
  content: 'time tracking, time tracking tool, online time tracking, free time
            tracking, 1-click time tracking, productivity tools, time tracker,
            timetracker, time tracker software, timetracking'
}]

# This serves as a basis for our other views, doing the "heavy lifting" of
# templating behind the scenes for us.
class View extends Backbone.View
  className: -> 'page'
  model: require './lib/user-state-model'

  initialize: ->
    @meta ?= DEFAULT_META_TAGS
    @listenTo @model, 'change:logged', @changeHeader

  remove: ->
    # There's no View::triggerMethod without Marionette
    @onBeforeRemove?()
    @trigger('before:remove')
    super
    @onRemove?()
    @trigger('remove')

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

  changeHeader: (model, logged) ->
    @$('.not-logged').toggle not logged
    @$('.logged').toggle logged

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
    hook(this) for hook in hooks.view
    # Run page hooks
    hooks.page[hook](this) for hook in @hooks if @hooks?

module.exports = View

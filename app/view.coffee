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
  attributes: {}

  initialize: ->
    @meta ?= DEFAULT_META_TAGS
    @listenTo @model, 'change:logged', @updateLogged

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
    @updateLogged @model, @model.get('logged')
    return this

  updateLogged: (model, logged) ->
    if logged
      @$('.not-logged').css('display', 'none')
      @$('.logged').attr('style', '') # removes js-defined styles
    else
      @$('.not-logged').attr('style', '')
      @$('.logged').css('display', 'none')

  changeMetaTags: ->
    CUSTOM_META_CLASS = 'custom-meta-tag'
    # Remove all old custom meta tags
    $(".#{CUSTOM_META_CLASS}").remove()
    for metaOpts in @meta
      tag = $ '<meta/>', _.extend metaOpts, class: CUSTOM_META_CLASS
      $('head').prepend tag

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

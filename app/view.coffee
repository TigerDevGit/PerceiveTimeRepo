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
  content: 'Leading employee time management software. Features a simple online timer, visual timesheet reports and billable hours that help see where the time goes.'
}, {
  name: 'Keywords'
  content: 'time tracking, online timer, timesheets, time management system, employee time tracking, productivity tracking, work hours'
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
    @updateCanonicalTag()
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

  updateCanonicalTag: ->
    address = window.location.href
    address = address.replace('www.', '') # remove www
    address = address.replace(/\?.*/, '') # remove url query
    if _.endsWith(address, '/')
      address = address.slice(0, -1) # remove trailing slash
    $('[rel=canonical]').remove()
    tag = $('<meta/>', rel: 'canonical', href: address)
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

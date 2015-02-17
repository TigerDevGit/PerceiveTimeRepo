Backbone = require 'backbone'
$        = require 'jquery'
Backbone.$ = $
class SiteOptionsModel extends Backbone.Model
  url: '/site_options.json'

  initialize: ->
    @fetch()

instance = null
module.exports = -> instance ?= new SiteOptionsModel()

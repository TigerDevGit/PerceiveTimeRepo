$ = require 'jquery'
Backbone = require 'Backbone'
Backbone.$ = $

Handlebars = require 'handlebars'
templates = require('./templates/compiled')(Handlebars)

# This serves as a basis for our other views, doing the "heavy lifting" of
# templating behind the scenes for us.
class View extends Backbone.View
    el: '.page'
    render: ->
      this.$el.html templates[@template](@attributes)

      if @title?
        document.title = @title

module.exports = View

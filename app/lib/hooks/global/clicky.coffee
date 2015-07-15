$ = require 'jquery'
Backbone = require 'backbone'
clicky = require 'clicky-loader'

clicky.init 100857897

module.exports = (router) ->
  clicky.log '/', document.title, 'pageview'
  router.on 'route', ->
    route = document.location.pathname
    clicky.log route, document.title, 'pageview'

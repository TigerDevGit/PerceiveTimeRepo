Backbone = require 'Backbone'
clicky = require 'clicky-loader'
$ = require 'jquery'

clicky.init 100857897

DATA_KEY = '[data-clicky]'

$(document).on 'click', DATA_KEY, (e) ->
  action = $(e.currentTarget).closest(DATA_KEY).data('clicky')?.split(':')
  url   = document.location.pathname
  title = action[0]
  type  = action[1]
  clicky.log url, title, type

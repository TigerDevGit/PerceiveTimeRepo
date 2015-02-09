'use strict'
gulp = require 'gulp'

exports.browserify = ->
  gulp.watch ['app/**/*.coffee', 'app/*.coffee'], ['browserify']

exports.assets = ->
  gulp.watch 'app/assets', ['copy:assets']

exports.handlebars = ->
  gulp.watch ['./app/templates/*.hbs', './app/templates/**/*.hbs'], ['handlebars', 'browserify']

exports['toggl-javascript'] = ->
  gulp.watch ['./app/lib/hooks/page/*.js'], ['copy', 'browserify']

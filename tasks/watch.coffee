'use strict'
gulp = require 'gulp'
notify = require 'gulp-notify'

exports.browserify = ->
  gulp.watch ['./app/**/*.coffee', './app/*.coffee'], ['browserify:toggl']

exports.assets = ->
  gulp.watch './app/assets/*', ['copy:assets']

exports.handlebars = ->
  gulp.watch(
    ['./app/templates/*.hbs', './app/templates/**/*.hbs'],
    ['handlebars', 'browserify:toggl']
  )

exports['toggl-javascript'] = ->
  gulp.watch ['./app/lib/hooks/page/*.js'], ['copy', 'browserify']

exports._after = ->
  notify('Done').write({})

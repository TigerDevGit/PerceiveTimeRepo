'use strict'
gulp = require 'gulp'

exports.browserify = ->
  gulp.watch ['app/**/*.coffee', 'app/*.coffee'], ['browserify']

exports.assets = ->
  gulp.watch 'app/assets', ['copy:assets']

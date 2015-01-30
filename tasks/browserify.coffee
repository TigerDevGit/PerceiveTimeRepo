'use strict'
browserify = require 'browserify'
gulp = require 'gulp'
refresh = require 'gulp-livereload'
sourcemaps = require 'gulp-sourcemaps'
buffer = require 'vinyl-buffer'
source = require 'vinyl-source-stream'

lrserver = require('./serve')._lrserver

NO_SOURCE_MAPS = process.env.NO_SOURCE_MAPS || false
NO_MINIFYFY = process.env.NO_MINIFYFY || false

# External packages to be put in the "vendor" browserify bundle
EXTERNAL_MODULES = Object.keys(require('../package.json').dependencies)

exports.toggl = ->
  bundler = browserify(
    entries: './app/toggl.coffee'
    extensions: ['.coffee', '.hbs']
    debug: if NO_MINIFYFY and NO_SOURCE_MAPS then false else true
  )

  bundler.external(EXTERNAL_MODULES)
  bundler.transform('coffeeify')
  bundler.transform('folderify')
  bundler.plugin('minifyify',
    output: './dist/javascripts/toggl.map.json'
    map: if NO_SOURCE_MAPS then false else '/javascripts/toggl.map.json'
  ) unless NO_MINIFYFY

  bundler.bundle()
    .pipe(source('toggl.js'))
    .pipe(buffer())
    .pipe(gulp.dest('./dist/javascripts/'))
    .pipe(refresh(lrserver))

exports.vendor = ->
  bundler = browserify(
    entries: []
    debug: if NO_MINIFYFY and NO_SOURCE_MAPS then false else true
  )

  bundler.require(EXTERNAL_MODULES)
  bundler.plugin('minifyify',
    output: './dist/javascripts/vendor.map.json'
    map: if NO_SOURCE_MAPS then false else '/javascripts/vendor.map.json'
  ) unless NO_MINIFYFY
  bundler.bundle()
    .pipe(source('vendor.js'))
    .pipe(buffer())
    .pipe(gulp.dest('./dist/javascripts/'))
    .pipe(refresh(lrserver))

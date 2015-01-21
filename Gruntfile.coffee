"use strict"
request    = require 'request'
path       = require 'path'
timerStart = Date.now()

module.exports = (grunt) ->

  # load all grunt tasks
  require("matchdep").filterDev("grunt-*").forEach grunt.loadNpmTasks

  # configurable paths
  yeomanConfig =
    app: "app"
    dist: "dist"
    tmp: ".tmp"

  # external packages to be put in the "vendor" browserify bundle
  external = [
    "jquery"
    "backbone"
    "underscore"
    "handlebars"
  ]

  pkg = grunt.file.readJSON("package.json")
  grunt.initConfig
    yeoman: yeomanConfig
    connect:
      options:
        port: 9001
        hostname: "localhost"
        base: "<%= yeoman.dist %>"

      dist:
        options:
          keepalive: false

    clean:
      dist: [
        ".tmp"
        "<%= yeoman.dist %>/*"
      ]
      server: ".tmp"

    imagemin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/images"
          src: "{,*/}*.{png,jpg,jpeg}"
          dest: "<%= yeoman.dist %>/images"
        ]

    htmlmin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>"
          src: "*.html"
          dest: "<%= yeoman.dist %>"
        ]


    # Put files not handled in other tasks here
    copy:
      dist:
        expand: true
        cwd: "<%= yeoman.app %>/assets"
        src: '**/*'
        dest: "<%= yeoman.dist %>/"

      appjs:
        expand: true
        cwd: "<%= yeoman.app %>"
        src: 'lib/**/*.js'
        dest: ".tmp/app"

    togglRelease:
      staging: [
        host: "hubert"
        port: 22
        username: "toggl"
        root: "/home/toggl/toggl_website"
      ]
      # Disabled for now.
      # production: [
      #   {
      #     host: "23.253.62.226"
      #     port: 666
      #     username: "toggl"
      #     root: "/home/toggl/toggl_website"
      #   }
      #   {
      #     host: "23.253.200.66"
      #     port: 666
      #     username: "toggl"
      #     root: "/home/toggl/toggl_website"
      #   }
      # ]

    compress:
      options:
        mode: "gzip"

      dist:
        expand: true
        src: [
          "<%= yeoman.dist %>/**/*.js"
          "<%= yeoman.dist %>/**/*.css"
          "<%= yeoman.dist %>/**/*.html"
        ]
        dest: "."

    autoprefixer:
      css:
        src: "<%= yeoman.app %>/assets/stylesheets/style.css"
        dest: "<%= yeoman.dist %>/stylesheets/style.autoprefixed.css"

    watch:
      css:
        files: "<%= yeoman.app %>/assets/stylesheets/style.css"
        tasks: ["autoprefixer"]

    coffee:
      dist:
        files: [{
          expand: true
          cwd: "<%= yeoman.app %>"
          src: "**/*.coffee"
          dest: ".tmp/app"
          ext: ".js"
        }]

    browserify:
      app:
        src: [".tmp/app/**/*.js"]
        dest: "<%= yeoman.dist %>/javascripts/toggl.js"
        options:
          external: external
      vendor:
        src: []
        dest: "<%= yeoman.dist %>/javascripts/vendor.js"
        options:
          require: external

    handlebars:
      dist:
        options:
          namespace: false
          commonjs: true
          processName: (f) -> f.replace("app/templates/", "").replace(".hbs", "")
          partialRegex: /.*/,
          partialsPathRegex: /\/partials\//

        src: "<%= yeoman.app %>/templates/**/*.hbs"
        dest: ".tmp/app/templates/compiled.js"

  grunt.registerTask "serve", [
    "build"
    "connect:dist"
    "watch:css"
  ]

  #Do this dynamically After version were bumped.
  grunt.registerTask "build", [
    "clean"
    "coffee"
    "handlebars"
    "copy:appjs"
    "browserify"
    "autoprefixer"
    "copy:dist"
  ]

  grunt.registerTask "deployInfo", []

  grunt.registerTask "default", ["build"]

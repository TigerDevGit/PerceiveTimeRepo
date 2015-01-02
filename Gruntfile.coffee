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

  pkg = grunt.file.readJSON("package.json")
  grunt.initConfig
    yeoman: yeomanConfig
    connect:
      options:
        port: 9001
        hostname: "localhost"
        base: "<%= yeoman.app %>"

      dist:
        options:
          keepalive: true

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
        cwd: "<%= yeoman.app %>"
        src: '**/*'
        dest: "<%= yeoman.dist %>/"

    togglRelease:
      staging: [
        host: "hubert"
        port: 22
        username: "toggl"
        root: "/home/toggl/toggl_website"
      ]
      production: [
        {
          host: "23.253.62.226"
          port: 666
          username: "toggl"
          root: "/home/toggl/toggl_website"
        }
        {
          host: "23.253.200.66"
          port: 666
          username: "toggl"
          root: "/home/toggl/toggl_website"
        }
      ]

      dist:
        options:
          root: "<%= yeoman.dist %>"

      serve:
        options:
          root: "<%= yeoman.app %>"

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

  grunt.registerTask "serve", [
    "build"
    "connect:dist:keepalive"
  ]

  #Do this dynamically After version were bumped.
  grunt.registerTask "build", [
    "clean"
    "copy"
  ]

  grunt.registerTask "default", ["build"]

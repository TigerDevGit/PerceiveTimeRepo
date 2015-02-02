"use strict"

fs                = require 'fs'
path              = require 'path'
connectLiveReload = require 'connect-livereload'
matchdep          = require 'matchdep'
request           = require 'request'
_                 = require 'underscore'
{proxyRequest}    = require 'grunt-connect-proxy/lib/utils'

timerStart = Date.now()

API_HOST = "https://next.toggl.com" || process.env.API_HOST
API_HOST_USES_SSL = API_HOST.indexOf("https") == 0
LIVERELOAD_PORT = 35730 || process.env.LIVERELOAD_PORT

module.exports = (grunt) ->
  # load all grunt tasks
  matchdep.filterDev("grunt-*").forEach(grunt.loadNpmTasks)

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
    "es6-promise"
  ]

  grunt.initConfig
    yeoman: yeomanConfig

    karma:
      options:
        configFile: 'karma.conf.coffee'
      spec:
        singleRun: true
      watch:
        reporters: [ 'progress' ]
        singleRun: false
        watch: true

    connect:
      server:
        proxies: [
          {
            context: "/api/v8/"
            host: API_HOST['https://'.length..]
            https: API_HOST_USES_SSL
            protocol: if API_HOST_USES_SSL then 'https:' else 'http:'
            port: if API_HOST_USES_SSL then 443 else 80
          }
        ]
        options:
          port: 9001
          hostname: "localhost"
          debug: true
          livereload: LIVERELOAD_PORT
          base: "dist"
          middleware: (connect, options) ->
            # Make sure we can iterate through the `base` directories
            if not Array.isArray options.base
              options.base = [options.base]

            # Try serving static files first
            serveStaticFiles = options.base.map (dir) -> connect.static dir

            # Set-up the proxy
            proxyApiRequests = proxyRequest

            # Fallback to serving `index.html` so routing is handled by Backbone
            # in the client
            fallbackToIndex = (req, res, next) ->
              indexPath = path.join(__dirname, "dist/index.html")
              indexStream = fs.createReadStream indexPath
              indexStream.pipe res

            # Return the generated middleware Array
            serveStaticFiles.concat(proxyApiRequests, fallbackToIndex)

    coffeelint:
      options:
        configFile: 'coffeelint.json'
      app: [ "<%= yeoman.app %>/{,**/}*.coffee" ]

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
          cwd: "<%= yeoman.dist %>"
          src: "**/*.{png,jpg,jpeg}"
          dest: "<%= yeoman.dist %>"
        ]

    compress:
      dist:
        options:
          mode: "gzip"
        files: [
          { src: '<%= yeoman.dist %>/**/*.js', expand: true, ext: '.js.gz' }
          { src: '<%= yeoman.dist %>/**/*.html', expand: true, ext: '.html.gz' }
          { src: '<%= yeoman.dist %>/**/*.css', expand: true, ext: '.css.gz' }
        ]

    cssmin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.dist %>"
          src: "**/*.css"
          dest: "<%= yeoman.dist %>"
        ]

    htmlmin:
      dist:
        options:
          removeComments: true
          collapseWhitespace: true
        files: [
          expand: true
          cwd: "<%= yeoman.dist %>"
          src: "**/*.html"
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

      statics:
        expand: true
        cwd: "<%= yeoman.app %>/static-pages"
        src: '**/*'
        dest: "<%= yeoman.dist %>/"

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

    autoprefixer:
      css:
        src: "<%= yeoman.app %>/assets/stylesheets/style.css"
        dest: "<%= yeoman.dist %>/stylesheets/style.autoprefixed.css"

    watch:
      coffee:
        options: livereload: LIVERELOAD_PORT
        files: "<%= yeoman.app %>/{,**/}*.coffee"
        tasks: [ "build" ]
      handlebars:
        options: livereload: LIVERELOAD_PORT
        files: "<%= yeoman.app %>/templates/{,**/}*.hbs"
        tasks: [ "build" ]
      css:
        options: livereload: LIVERELOAD_PORT
        files: "<%= yeoman.app %>/assets/stylesheets/style.css"
        tasks: [ "build" ]

    coffee:
      dist:
        files: [{
          expand: true
          cwd: "<%= yeoman.app %>"
          src: "**/*.coffee"
          dest: ".tmp/app"
          ext: ".js"
        }]
        options:
          bare: true

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

    modernizr:
      dist:
        devFile: "remote"
        outputFile: "<%= yeoman.dist %>/javascripts/modernizr.js"
        parseFiles: false
        uglify: false
        extra:
          shiv: true
          load: true
          cssclasses: true

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

    rev:
      dist: [
        '<%= yeoman.dist %>/**/*.js'
        '<%= yeoman.dist %>/**/*.css'
        '<%= yeoman.dist %>/**/*.{png,jpg,jpeg,gif,webp}'
        '!<%= yeoman.dist %>/images/logo-big.png'
        '!<%= yeoman.dist %>/images/fb-share-img.png'
      ]

    useminPrepare:
      html: '<%= yeoman.dist %>/**/*.html'
      options:
        dist: '<%= yeoman.dist %>'

    usemin:
      html: ['<%= yeoman.dist %>/**/*.html']
      css: ['<%= yeoman.dist %>/**/*.css']

    # Filled by usemin
    concat: {}
    uglify: {}

  grunt.registerTask "serve", [
    'build:serve'
    'configureProxies:server'
    'connect:server'
    'watch'
  ]

  grunt.registerTask "build:serve", [
    "clean"
    "coffee"
    "handlebars"
    "copy:appjs"
    "browserify"
    "autoprefixer"
    "modernizr"
    "copy:dist"
    "copy:statics"
  ]

  grunt.registerTask "build", [
    "build:serve"
    "useminPrepare"
    "concat"
    "uglify"
    "imagemin"
    "cssmin"
    "rev"
    "usemin"
    "htmlmin"
    "compress"
  ]

  # Need those dummy tasks for our bad deploy job
  # Lets migrate those to something else...
  grunt.registerTask "deployInfo", []
  grunt.registerTask "staging", []

  grunt.registerTask "default", ["build"]

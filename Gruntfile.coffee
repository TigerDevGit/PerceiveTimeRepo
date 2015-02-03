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

  # External packages to be put in the "vendor" browserify bundle
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
          {
            context: "/app"
            host: 'localhost'
            port: 3000
          }
        ]
        options:
          port: process.env.PORT or 9001
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
        "snapshots"
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
        expand: true
        mode: "gzip"
        src: [
          "<%= yeoman.dist %>/**/*.js"
          "<%= yeoman.dist %>/**/*.css"
          "<%= yeoman.dist %>/**/*.html"
        ]
        dest: "."

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

    autoprefixer:
      notFound:
        expand: true
        flatten: true
        src: "<%= yeoman.app %>/static-pages/not-found/stylesheets/*.css"
        dest: "<%= yeoman.dist %>/not-found/stylesheets/"
        ext: ".autoprefixed.css"

      css:
        src: "<%= yeoman.app %>/assets/stylesheets/style.css"
        dest: "<%= yeoman.dist %>/stylesheets/style.autoprefixed.css"

    watch:
      coffee:
        options: livereload: LIVERELOAD_PORT
        files: "<%= yeoman.app %>/{,**/}*.coffee"
        tasks: [ "browserify:app" ]
      handlebars:
        options: livereload: LIVERELOAD_PORT
        files: "<%= yeoman.app %>/templates/{,**/}*.hbs"
        tasks: [ "build:serve" ]
      css:
        options: livereload: LIVERELOAD_PORT
        files: "<%= yeoman.app %>/assets/stylesheets/style.css"
        tasks: [ "build:serve" ]

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
        '!<%= yeoman.dist %>/not-found/**/*'
        '!<%= yeoman.dist %>/images/logo-big.png'
        '!<%= yeoman.dist %>/images/share-img/**/*'
        '!<%= yeoman.dist %>/images/tools/**/*'
        '!<%= yeoman.dist %>/photos/**/*'
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

    # Generate HTML snapshots for to make crawlers happy
    htmlSnapshot:
      all:
        options:
          # that's the path where the snapshots should be placed
          # it's empty by default which means they will go into the directory
          # where your Gruntfile.js is placed
          snapshotPath: '<%= yeoman.dist %>/static/',
          # This should be either the base path to your index.html file
          # or your base URL. Currently the task does not use it's own
          # webserver. So if your site needs a webserver to be fully
          # functional configure it here.
          sitePath: 'http://localhost:9001/',
          # you can choose a prefix for your snapshots
          # by default it's 'snapshot_'
          fileNamePrefix: '',
          # by default the task waits 500ms before fetching the html.
          # this is to give the page enough time to to assemble itself.
          # if your page needs more time, tweak here.
          msWaitForPages: 1000,
          # sanitize function to be used for filenames. Converts '#!/' to '_' as default
          # has a filename argument, must have a return that is a sanitized string
          sanitize: (requestUri) ->
            # returns 'index.html' if the url is '/', otherwise a prefix
            return 'index' if requestUri is "#"
            requestUri.replace(/#\//g, '') + "/index"

          # if you would rather not keep the script tags in the html snapshots
          # set `removeScripts` to true. It's false by default
          removeScripts: true,
          # set `removeLinkTags` to true. It's false by default
          removeLinkTags: true,
          # set `removeMetaTags` to true. It's false by default
          removeMetaTags: true,
          # allow to add a custom attribute to the body
          bodyAttr: 'data-prerendered'
          # here goes the list of all urls that should be fetched
          urls: [
            '#'
            '#/features'
            '#/about'
            '#/signup'
            '#/legal/terms'
            '#/legal/privacy'
            '#/landing'
            '#/tools'
            '#/forgot-password'
          ]

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
    "copy:statics"
    "copy:dist"
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
    "htmlSnapshot"
  ]

  grunt.registerTask "default", ["build"]

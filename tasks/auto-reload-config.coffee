'use strict'
child_process = require 'child_process'
chalk = require 'chalk'
gulp = require 'gulp'
gutil = require 'gulp-util'

spawn = child_process.spawn

exports.gulp = ->
  child = undefined
  restart = ->
    if child
      gutil.log(chalk.red("!! Killing Gulp process #{child.pid}"))
      child.kill()
    gutil.log("#{chalk.red('!!')} Starting Gulp child process")
    child = spawn 'gulp', ['all'],
      stdio: 'inherit'

    gutil.log("#{chalk.red('!!')} Child running at PID
               #{chalk.magenta(child.pid)}")
  gulp.watch ['gulpfile.coffee', 'tasks/*.coffee'], ->
    gutil.log("#{chalk.red('!!')} Gulp configuration changed")
    restart()
  restart()

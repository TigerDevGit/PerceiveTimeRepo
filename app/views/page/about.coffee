View = require '../../view'
JobPopup = require '../component/jobs-popup'
$ = require 'jquery'

class AboutView extends View
  template: 'page/about'
  title: 'Team — Toggl, The Simplest Time Tracker'

  postRender: ->
    $('.js-jobs-popup', @$el).on 'click', (e) ->
      e.preventDefault()
      new JobPopup().render()

module.exports = AboutView

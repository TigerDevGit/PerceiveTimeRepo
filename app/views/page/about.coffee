View = require '../../view'
JobPopup = require '../component/jobs-popup'
$ = require 'jquery'

class AboutView extends View
  template: 'page/about'
  title: 'Toggl - Team Behind the Best Time Tracker'
  meta: [
    name: 'description'
    content: 'Get better overview of the productive and awesome people behind Toggl - the best free time tracking tool in the cloud. Check it out!'
  ]

  postRender: ->
    $('.js-jobs-popup', @$el).on 'click', (e) ->
      e.preventDefault()
      new JobPopup().render()

module.exports = AboutView

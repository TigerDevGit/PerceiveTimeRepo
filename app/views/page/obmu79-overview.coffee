View = require '../../view'

class OverviewObm79 extends View
  className: 'page overview-page'
  template: 'page/overview-obm79'
  title: 'Overview — Toggl, The Simplest Time Tracker'

  events:
    'click .cta-button': 'clickStart'

  # Initializes a Toggl Overview to be shown after Sign Up.
  #
  # @parameter [Obm] obm
  initialize: ({ @obm }) ->
    super

  clickStart: ->
    @obm.sendAction 'click'

module.exports = OverviewObm79

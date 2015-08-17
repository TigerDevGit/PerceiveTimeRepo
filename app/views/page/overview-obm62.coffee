View = require '../../view'

class OverviewObm62 extends View
  className: 'page overview-page'
  template: 'page/overview-obm62'
  title: 'Overview — Toggl, The Simplest Time Tracker'

  events:
    'click .cta-button': 'clickStart'

  # Initializes a Toggl Overview to be shown after Sign Up. Only for OBMu62
  # users, currently.
  #
  # @parameter [Obm] obm
  #
  initialize: ({ @obm }) ->
    super

  clickStart: ->
    @obm.sendAction 'click'

module.exports = OverviewObm62

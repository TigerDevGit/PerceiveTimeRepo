View = require '../../view'
userState = require '../../lib/user-state-model'

obm = require '../../lib/obm'

class ObmU72Overview extends View
  className: 'page overview-page obmu72-overview-page'
  template: 'page/obmu72-overview'
  title: 'Overview — Toggl, The Simplest Time Tracker'

  initialize: ({@obm} = {}) ->
    super

  events:
    'click .cta-button': ->
      @obm.sendAction('click')

module.exports = ObmU72Overview

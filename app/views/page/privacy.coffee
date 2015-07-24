View = require '../../view'

class PrivacyView extends View
  template: 'page/privacy'
  title: 'Privacy Policy — Toggl, The Simplest Time Tracker'

  initialize: ({ simple }) ->
    super
    @attributes.simple = simple

module.exports = PrivacyView

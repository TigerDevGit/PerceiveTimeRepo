View = require '../../view'

class TermsView extends View
  template: 'page/terms'
  title: 'Terms of Service — Toggl, The Simplest Time Tracker'
  
  initialize: ({ simple }) ->
    super
    @attributes.simple = simple


module.exports = TermsView

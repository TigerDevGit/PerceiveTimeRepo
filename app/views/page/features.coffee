View = require '../../view'

class FeaturesView extends View
  template: 'page/features'
  title: 'Toggl Features - Leading Time Tracking Software'
  hooks: ['timer', 'piechart', 'reveal']

module.exports = FeaturesView

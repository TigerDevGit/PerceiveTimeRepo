View = require '../../view'

class FeaturesView extends View
  template: 'page/features'
  title: 'Toggl - Features Online Timer & Timesheet Export'
  meta: [
    name: 'description'
    content: 'Track project hours or general time usage. Analyze business profitability, personal productivity or keep track of employee timesheets.'
  ]
  hooks: ['timer', 'piechart', 'reveal']

module.exports = FeaturesView

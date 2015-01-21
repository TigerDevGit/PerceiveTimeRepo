View = require '../../view'

class IndexView extends View
  template: 'page/index'
  hooks: ['frontvideo', 'timer']
  title: 'Toggl - Free Time Tracking Software'

  initialize: ->
    @attributes =
      navLight: true

    return

module.exports = IndexView

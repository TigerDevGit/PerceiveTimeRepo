View = require '../../view'

class IndexView extends View
  template: 'index'
  hooks: ['frontvideo', 'timer']

module.exports = IndexView

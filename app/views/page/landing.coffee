View = require '../../view'

class LandingView extends View

  initialize: ({template, @title}) ->
    @template = "page/landing/#{template}"

module.exports = LandingView

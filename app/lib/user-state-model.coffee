Backbone = require 'backbone'
$        = require 'jquery'
class UserModel extends Backbone.Model
  url: '/api/v9/me/logged'

  initialize: ->
    @getLogged()

  getLogged: =>
    $.ajax
      url: @url
      dataType: 'text'
      success: => @set logged: true
      error: => @set logged: false

module.exports = new UserModel

Backbone = require 'backbone'
$        = require 'jquery'
class UserModel extends Backbone.Model
  url: '/api/v9/me/logged'

  initialize: ->
    @getLogged()

  getLogged: =>
    @set pending: true
    $.ajax
      url: @url
      dataType: 'text'
      success: => @set logged: true, pending: false
      error: => @set logged: false, pending: false

module.exports = new UserModel

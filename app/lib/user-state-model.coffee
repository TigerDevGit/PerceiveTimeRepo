Backbone = require 'backbone'

class UserModel extends Backbone.Model
  endpoint: '/api/v9'
  path: '/me/logged'

module.exports = new UserModel

$   = require 'jquery'
API = require '../../../lib/api'

module.exports = ($el) ->
  $('.js-logout-button', $el).on 'click', (e) ->
    e.preventDefault()
    new API('dev', null, null).auth.destroy()

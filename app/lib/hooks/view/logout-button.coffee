$   = require 'jquery'
API = require '../../../lib/api'

module.exports = ($el) ->
  $('.js-logout-button', $el).on 'click', (e) ->
    e.preventDefault()
    new API('TogglNext', null, null).auth.destroy()

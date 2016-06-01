$ = require 'jquery'

CUSTOM_ANALYTICS_ATTR = '[data-custom-analytics-event]'
$(document).on 'click', CUSTOM_ANALYTICS_ATTR, (e) ->
  event = $(e.currentTarget).closest(CUSTOM_ANALYTICS_ATTR).data('custom-analytics-event')
  woopra.track event

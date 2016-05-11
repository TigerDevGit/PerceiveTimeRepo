$ = require 'jquery'

CUSTOM_ANALYTICS_ATTR = '[data-custom-analytics-event]'
$(document).on 'click', CUSTOM_ANALYTICS_ATTR, (e) ->
  event = $(e.currentTarget).closest(CUSTOM_ANALYTICS_ATTR).data('custom-analytics-event')
  trackEvent event

trackEvent = (event) ->
  woopra.track('goal', { name: event })

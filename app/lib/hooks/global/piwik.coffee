$ = require 'jquery'

PIWIK_ATTR = '[data-piwik-event]'
$(document).on 'click', PIWIK_ATTR, (e) ->
  event = $(e.currentTarget).closest(PIWIK_ATTR).data('piwik-event')
  _paq.push ['trackEvent', 'Website', event]

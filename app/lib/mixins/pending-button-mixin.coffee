$ = require 'jquery'

# A mixin for easily updating a button's pending status. Assumes the object
# defined a property `submitButton` with the target button element.
PendingButtonMixin =
  isPending: -> $(@submitButton).hasClass 'pending'

  updateStatus: (status) ->
    $submitButton = @submitButton
    if @submitButtonTimeout
      clearTimeout(@submitButtonTimeout)

    switch status
      when 'pending'
        @submitButtonOriginalText = $submitButton.text()
        onTimeout = ->
          $submitButton.addClass('disabled pending cta-button--no-arrow')
          $submitButton.text('Loading...')
        @submitButtonTimeout = setTimeout(onTimeout, 300)
      else
        $submitButton.removeClass('disabled pending cta-button--no-arrow')
        $submitButton.text(@submitButtonOriginalText)

exports = module.exports = PendingButtonMixin

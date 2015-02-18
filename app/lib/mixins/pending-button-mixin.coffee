$ = require 'jquery'

# A mixin for easily updating a button's pending status. Assumes the object
# defined a property `submitButton` with the target button element.
pendingButtonMixin =
  isPending: -> $(@submitButton).hasClass 'pending'

  updateStatus: (status) ->
    $submitButton = @submitButton
    if @submitButtonTimeout
      clearTimeout(@submitButtonTimeout)

    switch status
      when 'pending'
        loader = @loader = @loader or document.createElement('div')

        @submitButtonOriginalText = $submitButton.text()
        onTimeout = ->
          loader.className = 'loader'
          $submitButton.css('height', $submitButton.outerHeight())
          $submitButton.html(loader)
          $submitButton.addClass('disabled pending cta-button--no-arrow')
        @submitButtonTimeout = setTimeout(onTimeout, 300)
      else
        $submitButton.css('height', '')
        $submitButton.text(@submitButtonOriginalText)
        $submitButton.removeClass('disabled pending cta-button--no-arrow')

exports = module.exports = pendingButtonMixin

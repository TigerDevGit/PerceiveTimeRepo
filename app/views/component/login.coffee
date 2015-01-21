View = require '../../view'
uniqueId = require '../../lib/unique-id'
$ = require 'jquery'
_ = require 'underscore'

class LoginPopup extends View
  template: 'component/login'

  initialize: ->
    # Teardown happens before the view is actually destroyed. Cleans
    # up the body class and removes the visible class, then waits
    # until the animation is done to trigger removal.
    @on 'teardown', ->
      $('body').removeClass 'with-modal-overlay'
      @modal.removeClass 'modal-overlay--visible'
      setTimeout (=> @trigger 'destroy'), 150

    @on 'destroy', ->
      @$el.remove()

    return

  # Before rending, insert an element on the page for the popup to
  # be drawn into.
  preRender: ->
    @el = '#' + uniqueId()
    @$el = $ '<div id="' + @el.slice(1) + '" />'
    $('body').append @$el

    return

  # Then bind hooks appropriately.
  postRender: ->
    # Add body styling
    $('body').addClass 'with-modal-overlay'

    # Teardown handlers
    teardown = => @trigger 'teardown'
    teardownKeypress = (e) => if e.keyCode is 27 then teardown()

    @modal = $('.modal-overlay', @$el)

    # Make the overlay visible and bind events to close when hit
    @modal.on 'click', (e) =>
        if e.target.classList.contains 'modal-overlay'
          teardown()

    _.defer => @modal.addClass 'modal-overlay--visible'

    # Add listeners for ESC and clicking on the close button
    $('.modal-overlay__close').on 'click', teardown
    $(document).on 'keypress', teardownKeypress

    # When the element is removed, clean up after itself.
    @on 'destroy', -> $(document).off 'keypress', teardownKeypress

    return

module.exports = LoginPopup

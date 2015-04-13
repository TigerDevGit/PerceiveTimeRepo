View = require '../../view'
uniqueId = require '../../lib/unique-id'
formData = require '../../lib/form-data'
API = require '../../lib/api'
$ = require 'jquery'
_ = require 'lodash'

class ModalView extends View

  initialize: ->
    super
    # Teardown happens before the view is actually destroyed. Cleans
    # up the body class and removes the visible class, then waits
    # until the animation is done to trigger removal.
    @on 'teardown', ->
      $('body').removeClass 'with-modal-overlay'
      @modal.removeClass 'modal-overlay--visible'
      setTimeout (=> @remove()), 150

    @on 'remove', ->
      @$el.remove()

    return

  # Binds teardown event handlers
  bindTeardown: ->
    # Teardown handlers
    teardown = => @trigger 'teardown'
    teardownKeypress = (e) -> if e.keyCode is 27 then teardown()

    # Make the overlay visible and bind events to close when hit
    @modal.on 'click', (e) ->
      if e.target.classList.contains 'modal-overlay'
        teardown()

    _.defer => @modal.addClass 'modal-overlay--visible'

    # Add listeners for ESC and clicking on the close button
    $('.modal-overlay__close').on 'click', teardown
    $(document).on 'keypress', teardownKeypress

    # When the element is removed, clean up after itself.
    @on 'remove', -> $(document).off 'keypress', teardownKeypress

  # Finds a adds jquery objects for re-used elements on the lgoin view.
  findElements: ->


  # Before rending, insert an element on the page for the popup to
  # be drawn into.
  preRender: ->
    @el = '#' + uniqueId()
    @$el = $ '<div id="' + @el.slice(1) + '" />'
    $('body').append @$el

    return

  # Then bind hooks appropriately.
  postRender: ->
    $('body').addClass 'with-modal-overlay'
    @modal = $ '.modal-overlay', @$el
    @bindTeardown()

    return

module.exports = ModalView

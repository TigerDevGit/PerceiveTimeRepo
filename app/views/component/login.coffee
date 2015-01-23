View = require '../../view'
uniqueId = require '../../lib/unique-id'
formData = require '../../lib/form-data'
API = require '../../lib/api'
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

  bindLoginForm: ->
    $error = @error
    $form = $('.login-form', @modal)
    $form.on 'submit', (e) ->
      e.preventDefault()
      $error.hide()
      data = formData $form

      new API().auth.session data.username, data.password
        .then ->
          alert 'You\'re logged in! Todo: do something :P'
        .catch ->
          $error.show()

  # Binds teardown event handlers
  bindTeardown: ->
    # Teardown handlers
    teardown = => @trigger 'teardown'
    teardownKeypress = (e) => if e.keyCode is 27 then teardown()

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

  # Finds a adds jquery objects for re-used elements on the lgoin view.
  findElements: ->
    @error = $ '.login-form__error', @$el
    @modal = $ '.modal-overlay', @$el

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

    @findElements()
    @bindLoginForm()
    @bindTeardown()

    return

module.exports = LoginPopup

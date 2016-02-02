ModalView = require './modal'

class LoginOverlay extends ModalView
  template: 'component/login-overlay'

  ui:
    message: '.js-modal-message'

  updateMessage: (message) -> @ui.message.text message

  close: =>
    @fadeAndRemove()

module.exports = LoginOverlay

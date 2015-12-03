ModalView = require './modal'

class LoginOverlay extends ModalView
  template: 'component/login-overlay'

  close: =>
    @fadeAndRemove()

module.exports = LoginOverlay

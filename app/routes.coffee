module.exports = [
  {
    route: ''
    name: 'index'
    view: require './views/page/index'
  }
  {
    route: 'signup'
    name: 'signup'
    view: require './views/page/signup'
  }
  {
    route: 'features'
    name: 'features'
    view: require './views/page/features'
  }
  {
    route: 'about'
    name: 'about'
    view: require './views/page/about'
  }
  {
    route: 'landing'
    name: 'landing'
    view: require './views/page/landing'
  }
  {
    route: 'tools'
    name: 'tools'
    view: require './views/page/tools'
  }
  {
    route: 'legal/privacy'
    name: 'privacy'
    view: require './views/page/privacy'
  }
  {
    route: 'legal/terms'
    name: 'terms'
    view: require './views/page/terms'
  }
  {
    route: 'forgot-password'
    name: 'forgotPassword'
    view: require './views/page/forgot-password'
  }
  {
    route: 'reset_password/:token'
    name: 'resetPassword'
    view: require './views/page/reset-password'
  }
  {
    route: '*notFound'
    name: 'notFound'
    view: require './views/page/not-found'
  }
]

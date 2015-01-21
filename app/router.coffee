Backbone = require 'backbone'
routes = require './routes'
$ = require 'jquery'

# Create a new backbone router with the routes specified
Router = Backbone.Router.extend
  routes: do ->
    out = {}
    for route in routes
      out[route.route] = route.name

    return out

router = new Router()
currentView = null
# Then listen for navigation to those routes and render accordingly
routes.forEach (route) ->
  router.on 'route:' + route.name, ->
    $(window).scrollTop 0
    currentView?.trigger 'destroy'
    currentView = new route.view().render()
    return
  return

module.exports = router

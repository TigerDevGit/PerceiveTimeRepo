Backbone = require 'Backbone'
routes = require './routes'

# Create a new backbone router with the routes specified
Router = Backbone.Router.extend
  routes: do ->
    out = {}
    for route in routes
      out[route.route] = route.name

    return out

router = new Router()
# Then listen for navigation to those routes and render accordingly
routes.forEach (route) ->
  router.on 'route:' + route.name, ->
    new route.view().render()
    return
  return

module.exports = router

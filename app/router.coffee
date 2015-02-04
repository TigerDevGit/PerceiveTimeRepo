Backbone = require 'backbone'
routes = require './routes'
window.$ = $ = require 'jquery'

# Create a new backbone router with the routes specified
Router = Backbone.Router.extend
  routes: do ->
    routes.reduce (old, route) ->
      old[route.route] = route.name
      old
    , {}

router = new Router()
currentView = null
# Then listen for navigation to those routes and render accordingly
routes.forEach (route) ->
  router.on 'route:' + route.name, ->
    $(window).scrollTop 0
    currentView?.trigger 'destroy'
    currentView = new route.view().render()
    window._gaq?.push [ '_trackPageview', route.route ]
    $(document.body).attr id: route.name

module.exports = router

fs = require 'fs'
path = require 'path'
livereload = require 'connect-livereload'
express = require 'express'
proxy = require 'express-http-proxy'
tinylr = require 'tiny-lr'

PORT = process.env.PORT || 9001
LIVERELOAD_PORT = process.env.LIVERELOAD_PORT || 35729
TOGGL_API_URL = process.env.TOGGL_API_URL || 'https://next.toggl.com/'
TOGGL_WEBAPP_URL = process.env.TOGGL_WEBAPP_URL || 'http://localhost:3000'

exports._devserver = devserver = express()
devserver.use(livereload port: LIVERELOAD_PORT)
devserver.use('/api*', proxy(TOGGL_API_URL))
devserver.use('/app*', proxy(TOGGL_WEBAPP_URL))
devserver.use(express.static('./dist'))
devserver.use((req, res, next) ->
  indexPath = path.join(__dirname, "../dist/index.html")
  indexStream = fs.createReadStream indexPath
  indexStream.pipe res
)

exports['start-devserver'] = ->
  devserver.listen PORT

exports._lrserver = lrserver = tinylr()

exports['start-lrserver'] = ->
  lrserver.listen LIVERELOAD_PORT

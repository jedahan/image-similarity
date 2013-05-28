pHash = require 'phash'
restify = require 'restify'
toobusy = require 'toobusy'
swagger = require 'swagger-doc'
redis = require 'redis'
async = require 'async'

###
  Database
###
redis_url = require("url").parse(process.env.REDIS_URL or 'http://127.0.0.1:6379')
db = require("redis").createClient redis_url.port, redis_url.hostname
db.auth redis_url.auth.split(":")[1] if redis_url.auth?

db.on 'error', (err) ->
  console.error err

_check_if_busy = (req, res, next) ->
  if toobusy()
    res.send 503, "I'm busy right now, sorry."
  else next()

upload = (req, res, next) ->
  db.set pHash.getImageHash(req.files.image.path), req.files.image.path, (err) ->
    res.send err or req.files.image.path

search = (req, res, next) ->
  scores = []
  hash = pHash.getImageHash req.files.image.path
  distance = (element, callback) ->
    db.get element, (err, path) ->
      scores.push
        path: req.headers.host + path.match(/static(.*)/)[1]
        distance: pHash.hammingDistance hash, element
      callback()

  db.keys "*", (err, hashes) ->
    console.error err if err?
    async.each hashes, distance, (err) ->
      res.send err or scores.sort (a,b) -> a.distance - b.distance

###
  Server Options
###
server = restify.createServer()
server.pre restify.pre.userAgentConnection() # fix curl clients
server.use _check_if_busy # 503 if server is overloaded
server.use restify.acceptParser server.acceptable # use accept headers
server.use restify.bodyParser uploadDir: 'static/uploads' # for uploads
server.use restify.queryParser()  # parse query variables
server.use restify.fullResponse() # set CORS, eTag, other common headers
server.use restify.gzipResponse() # compress response

###
  Routes
###
server.post "/search", search
server.post "/upload", upload

###
  Documentation
###
swagger.configure server
docs = swagger.createResource '/docs'
docs.post "/upload", "Upload new image to database",
  nickname: "upload"
  parameters: [
    { name: 'image', description: 'image to upload, store hash and path', required: true, dataType: 'file', paramType: 'body' }
  ]

docs.post "/search", "Gets a list of ids based on a search query",
  nickname: "getQuery"
  parameters: [
    { name: 'image', description: 'image to search against', required: true, dataType: 'file', paramType: 'form' }
  ]

###
  Static files
###
server.get /\/*/, restify.serveStatic directory: './static', default: 'index.html', charSet: 'UTF-8'

server.listen process.env.PORT or 80, ->
  console.log "[%s] #{server.name} listening at #{server.url}", process.pid

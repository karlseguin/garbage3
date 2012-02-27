module.exports.require = (path) ->
  require('../src/' + path)

module.exports.controller = (method, path) ->
  app = new FakeApp()
  require('../src/manager/controller')(app)
  app.routes[method][path]

module.exports.storeBeforeEach = (next) ->
  store = require('../src/store')
  store.initialize {host: '127.0.0.1', port: 6379, db: 1}, ->
    store.instance.flushdb ->
      next()

module.exports.storeAfterEach = ->
  instance = require('../src/store').instance
  instance.end() if instance? && instance.connected

module.exports.expectSendWithError = (error, socket) ->
  error.cmd = 'error'
  expect(socket.send).toHaveBeenCalledWith(JSON.stringify(error), jasmine.any(Function))

class FakeApp
  constructor: ->
    @routes = {get: {}, post: {}, put: {}, delete: {}}

  get: (path, cb) ->
    @routes.get[path] = (context) -> cb(context.request, context.response)

  post: (path, cb) ->
    @routes.post[path] = (context) -> cb(context.request, context.response)

  put: (path, cb) ->
    @routes.put[path] = (context) -> cb(context.request, context.response)

  delete: (path, cb) ->
    @routes.delete[path] = (context) -> cb(context.request, context.response)

class FakeContext
  constructor: (request) ->
    @request = request || {}

    @response =
      invalid: (errors) ->
        @writeHead(400, {'Content-Type', 'application/json'})
        @end(JSON.stringify(errors))
      valid: (body) ->
        @writeHead(200, {'Content-Type', 'application/json'})
        @end(JSON.stringify(body))
      writeHead: (code, headers) =>
        @responseCode = code
        @responseHeaders = headers
      end: (body) =>
        @responseBody = body

  assertInvalid: (errors) ->
    @assertResponse(400, errors)

  assertValid: (body) ->
    @assertResponse(200, body)

  assertResponse: (status, body) ->
    expect(@responseCode).toEqual(status)
    expect(@responseHeaders).toEqual({'Content-Type', 'application/json'})
    expect(JSON.parse(@responseBody)).toEqual(body)

module.exports.FakeContext = FakeContext
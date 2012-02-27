Room = require('./../models/room')
http = require('http')

invalid = (res, errors) ->
  errors = {error: errors} if typeof errors == 'string'
  res.writeHead(400, {'Content-Type', 'application/json'})
  res.end(JSON.stringify(errors))

valid = (res, body) ->
  res.writeHead(200, {'Content-Type', 'application/json'})
  res.end(JSON.stringify(body))

module.exports = (app) ->
  app.post '/rooms', (req, res) ->
    Room.create req.body.name, {}, (err, ok) ->
      return invalid(res, err) if err?   #log the error and return a generic error message
      valid(res, {created: ok})

  app.get '/rooms', (req, res) ->
    Room.list (err, rooms) ->
      return invalid(res, err) if err?
      valid(res, rooms)
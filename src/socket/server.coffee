config = require('./../config')
store = require('./../store')
queue = require('./../queue')
client = require('./../models/client')
connection = require('./connection')

store.initialize config.store, (err) ->
  if err?
    console.log('store initialization error: %s', err)
    process.exit(1)
  
  queue.initialize config.queue, (err) ->
    if err?
      console.log('store initialization error: %s', err)
      process.exit(1)
      
    connect = require('connect')
    server = connect()

    WebSocketServer = require('ws').Server
    wss = new WebSocketServer({server: server, verifyClient: client.verify})
    wss.on 'connection', connection.create
    server.listen(config.socket.port)
    console.log('socket server running on port %d', config.socket.port)
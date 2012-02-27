store = require('../store')
queue = require('../queue')

class Room
  @cached = {}

  constructor: (@name, @config) ->
    @connections = []
    @connectionsLookup = {}
    @broadcastName = 'room:' + @name

  userJoin: (connection, callback) =>
    client = connection.client
    store.addUserToRoom @name, client, (err) =>
      return callback(err) if err?
      @broadcast('joined', {id: client.id, name: client.name})
      index = @connectionsLookup[client.id]
      if index?
        @connections[index] = connection
      else
        #todo compact with userLeave
        length = @connections.length 
        @connections.push(connection)
        @connectionsLookup[client.id] = length
      callback()

  userLeave: (connection) =>
    #todo, delete the room if this was the last user
    client = connection.client
    store.removeUserFromRoom @name, client

    index = @connectionsLookup[client.id]
    if index?
      @connections[index] = null 
      delete @connectionsLookup[client.id]

    @broadcast('leave', {id: client.id, name: client.name})
    

  message: (client, message) =>
    @broadcast('mesg', {client: client, message: message})

  broadcast: (command, payload) =>
    payload.cmd = command
    payload.room = @name
    queue.publish @broadcastName, payload

  dispatch: (raw) =>
    data = JSON.parse(raw)
    for connection in @connections when connection?
      connection.send(data)

  @create: (name, config, callback) ->
    #todo validate name and config
    store.createRoom name, config, (err, ok) =>
      return callback(err, ok) if err? || !ok
      callback(null, ok)

  @load: (name, callback) ->
    room = @cached[name]
    return callback(null, room) if room?

    store.loadRoom name, (err, data) =>
      return callback(err, data) if err? || !data?
      room = new Room(name, data.conf)
      queue.subscribe room.broadcastName
      queue.on room.broadcastName, room.dispatch
      @cached[name] = room
      callback(null, room)

  @list: (callback) -> store.listRooms callback

module.exports = Room
store = require('./../store').instance
errors = require('./../errors')
Room = require('./../models/room')

class Connection
  constructor: (@socket, @client) ->
    @rooms = {}

  dispatch: (raw, flags) =>
    data = null
    try
      data = JSON.parse(raw)  
    catch error
      return @sendError(errors.invalidMessage())
    
    if data.cmd == 'join'
      this.joinRoom(data)
    else if data.cmd == 'mesg'
      this.sendMessage(data)
    else if data.cmd == 'leave'
      this.leaveRoomByName(data)
    else
      @sendError(errors.unknownCommand())

  joinRoom: (payload) =>
    name = payload.name
    Room.load name, (err, room) =>
      return @sendError(errors.generic(err)) if err?
      return @sendError(errors.roomDoesNotExist()) unless room?

      room.userJoin @, (err) =>
        return @sendError(errors.generic(err)) if err?
        @rooms[name] = room
        @send('join', {name: room.name})

  sendMessage: (payload) =>
    room = @rooms[payload.room]
    return @sendError(errors.notInRoom()) unless room? 
    room.message @client, payload.message

  leaveRoomByName: (payload) =>    
    room = @rooms[payload.name]
    return @sendError(errors.notInRoom()) unless room? 
    @leaveRoom(room)

  leaveRoom: (room) =>
    room.userLeave @
    delete @rooms[room.name]
    
  sendError: (payload) =>
    @send('error', payload)

  send: (command, payload) =>
    if payload?
      payload.cmd = command
    else
      payload = command
    @socket.send JSON.stringify(payload), (err) =>
      @close()

  close: =>
    @leaveRoom(room) for room in @rooms
        

  @create: (socket) ->
    connection = new Connection(socket, socket.upgradeReq._client)
    socket.on 'message', connection.dispatch
    socket.on 'close', connection.close
    connection



module.exports = Connection
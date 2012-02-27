config = require('./config')
WebSocket = require('ws')
Faker = require('Faker')

randomRoom = ->
  'room' + Math.ceil(Math.random() * config.rooms)

class Client
  constructor: (@name) ->
    @rooms = []
    @ready = false
    @socket = new WebSocket('ws://' + config.server.host + ':' + config.server.port + '/?' + @name)
    @socket.on 'open', () => @ready = true

  run: =>
    setTimeout ( =>
      @doAction()
    ), 1000
  
  doAction: =>
    if !@ready
    else if @rooms.length < config.roomsPerClient
      @joinRoom()
    else
      rand = Math.ceil(Math.random() * 25)
      if rand == 1
        @leaveRoom()
      else
        @sendMessage()

    @run()

  joinRoom: =>
    room = null
    loop
      room = randomRoom()

      exists = false
      for existing in @rooms
        if existing == room
          exists = true
          break
      continue if exists

      @rooms.push(room)
      break

    @send 'join', {name: room}
    @joinRoom() if @rooms.length < config.roomsPerClient

  leaveRoom: =>
    index = Math.floor(Math.random() * @rooms.length)
    @send 'leave', {name: @rooms[index]}
    newRooms = []
    for room in @rooms when room?
      newRooms.push(room)
    @rooms = newRooms

  sendMessage: =>
    index = Math.floor(Math.random() * @rooms.length)
    @send 'mesg', {room: @rooms[index], message: Faker.Lorem.sentence()}

  send: (command, payload) =>
    payload.cmd = command
    @socket.send(JSON.stringify(payload))

module.exports = Client
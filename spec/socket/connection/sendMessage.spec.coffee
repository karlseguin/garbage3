helper = require('../../helper')
errors = helper.require('./errors')
Room = helper.require('./models/room')
Connection = helper.require('./socket/connection')
Client = helper.require('./models/client')

describe 'Conncetion', ->
  describe 'Send Message', ->

    it "returns error if the user is not in the room", ->
      socket = {send: jasmine.createSpy()}
      new Connection(socket).sendMessage({room: 'a-room'})
      helper.expectSendWithError(errors.notInRoom(), socket)


    it "tells the room about the message", ->
      client = new Client()
      connection = new Connection({}, client)
      room = new Room({})
      connection.rooms['the-room'] = room
      spyOn(room, 'message')
      connection.sendMessage({room: 'the-room', message: 'look at me'})
      expect(room.message).toHaveBeenCalledWith(client, 'look at me')
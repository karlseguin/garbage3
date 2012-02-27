helper = require('../../helper')
errors = helper.require('./errors')
Room = helper.require('./models/room')
Connection = helper.require('./socket/connection')
Client = helper.require('./models/client')

describe 'Conncetion', ->
  describe 'Leave Room By Name', ->

    it "returns error if the user is not in the room", ->
      socket = {send: jasmine.createSpy()}
      new Connection(socket).leaveRoomByName({room: 'a-room'})
      helper.expectSendWithError(errors.notInRoom(), socket)

    it "tells the room that the user has left", ->
      connection = new Connection({}, new Client())
      room = new Room('the-room')
      connection.rooms['the-room'] = room
      spyOn(room, 'userLeave')
      connection.leaveRoomByName({name: 'the-room'})
      expect(room.userLeave).toHaveBeenCalledWith(connection)
      expect(connection.rooms).toEqual([])
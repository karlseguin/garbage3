helper = require('../../helper')
errors = helper.require('./errors')
Room = helper.require('./models/room')
Connection = helper.require('./socket/connection')
Client = helper.require('./models/client')

describe 'Conncetion', ->
  describe 'Join Room', ->
    
    it "returns error on load room failure", ->
      socket = {send: jasmine.createSpy()}
      spyOn(Room, 'load').andCallFake (name, cb) -> cb('some error')
      new Connection(socket).joinRoom({name: 'cal'})
      helper.expectSendWithError(errors.generic('some error'), socket)

    it "returns error if the room doesn't exist", ->
      socket = {send: jasmine.createSpy()}
      spyOn(Room, 'load').andCallFake (name, cb) -> cb(null, null)
      new Connection(socket).joinRoom({name: 'lac'})
      helper.expectSendWithError(errors.roomDoesNotExist(), socket)

    it "returns error if theu user cannot be added to the room", ->
      socket = {send: jasmine.createSpy()}  

      client = new Client()
      room = new Room('the-name')    
      spyOn(Room, 'load').andCallFake (name, cb) -> cb(null, room)
      spyOn(room, 'userJoin').andCallFake (client, cb) -> cb('errX')
      
      new Connection(socket).joinRoom({name: 'cla'})
      helper.expectSendWithError(errors.generic('errX'), socket)

    it "adds the user to the room and returns the room details", ->
      socket = {send: jasmine.createSpy()} 
      connection = new Connection(socket) 

      room = new Room('the-name')    
      spyOn(Room, 'load').andCallFake (name, cb) -> 
        expect(name).toEqual('cla')
        cb(null, room)

      spyOn(room, 'userJoin').andCallFake (c, cb) ->
        expect(c).toBe(connection)
        cb(null)
    
      connection.joinRoom({name: 'cla'})
      expect(socket.send).toHaveBeenCalledWith(JSON.stringify({name: 'the-name', cmd: 'join'}), jasmine.any(Function))
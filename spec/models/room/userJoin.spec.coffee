helper = require('../../helper')
Room = helper.require('./models/room')
Connection = helper.require('./socket/connection')
Client = helper.require('./models/client')
store = helper.require('./store')

describe 'Room',  ->
  describe 'User Join', ->
    it "returns error if user can't be added to the store", ->
      spyOn(store, 'addUserToRoom').andCallFake (name, client, cb) -> cb('err2')
      new Room().userJoin new Client(), (err) ->
        expect(err).toEqual('err2')

    it "broadcasts the user having joined the room", ->
      client = new Client(12, 'leto')
      connection = new Connection(null, client)
      room = new Room()

      spyOn(room, 'broadcast')
      spyOn(store, 'addUserToRoom').andCallFake (name, client, cb) -> 
        expect(client).toBe(client)
        cb(null)

      room.userJoin connection, (err) ->
        expect(room.broadcast).toHaveBeenCalledWith('joined', {id: 12, name: 'leto'})
     
    it "adds the connection to the room", ->
      client = new Client('1', 'a')
      connection = new Connection(null, client)
      room = new Room()

      spyOn(room, 'broadcast')
      spyOn(store, 'addUserToRoom').andCallFake (name, client, cb) -> cb(null)

      room.userJoin connection, (err) ->
        expect(room.connections).toEqual([connection])
        expect(room.connectionsLookup).toEqual({'1':0})
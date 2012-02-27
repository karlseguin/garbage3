helper = require('../../helper')
Room = helper.require('./models/room')
Connection = helper.require('./socket/connection')
Client = helper.require('./models/client')
store = helper.require('./store')

describe 'Room',  ->
  describe 'User Leave', ->
    it "removes the user from the store", ->
      client = new Client(9, 'bbz')
      room = new Room("spice")
      connection = new Connection(null, client)
      
      spyOn(room, 'broadcast')
      spyOn(store, 'removeUserFromRoom')
      
      room.userLeave(connection)
      expect(store.removeUserFromRoom).toHaveBeenCalledWith("spice", client)
      expect(room.broadcast).toHaveBeenCalledWith('leave', {id: 9, name: 'bbz'})

    it "removes the user the user list", ->
      client = new Client(9, 'bbz')
      room = new Room("spice")
      connection = new Connection(null, client)
      room.connections = [connection]
      room.connectionsLookup = {9:0}
      
      spyOn(room, 'broadcast')
      spyOn(store, 'removeUserFromRoom')
      
      room.userLeave(connection)
      expect(room.connections).toEqual([null])
      expect(room.connectionsLookup).toEqual({})

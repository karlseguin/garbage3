helper = require('../../helper')
Room = helper.require('./models/room')
Client = helper.require('./models/client')
store = helper.require('./store')

describe 'Room',  ->
  describe 'Message', ->
    it "broadcasts the message", ->
      client = new Client()
      room = new Room()
      spyOn(room, 'broadcast')   
      room.message(client, 'hello world')
      expect(room.broadcast).toHaveBeenCalledWith('mesg', {client: client, message: 'hello world'})
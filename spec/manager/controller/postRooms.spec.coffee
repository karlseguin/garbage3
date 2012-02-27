helper = require('../../helper')
Room = helper.require('./models/room')
FakeContext = helper.FakeContext
controller = helper.controller('post', '/rooms')

describe 'Controller', ->
  describe 'Post Rooms', ->
    it "returns error", ->
      context = new FakeContext({body: {name: 'roomname'}})
      spyOn(Room, 'create').andCallFake (name, config, cb) -> cb('something bad happened')
      controller(context)
      context.assertInvalid({error: 'something bad happened'})

    it "creates the room and returns the result", ->
      context = new FakeContext({body: {name: 'roomname'}})
      spyOn(Room, 'create').andCallFake (name, config, cb) ->
        expect(name).toEqual('roomname')
        expect(config).toEqual({})
        cb(null, true)

      controller(context)
      context.assertValid({created: true})
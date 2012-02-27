helper = require('../../helper')
Room = helper.require('./models/room')
store = helper.require('./store')
queue = helper.require('./queue')

describe 'Room',  ->
  describe 'Create', ->
    beforeEach -> Room.cached = {}
    
    it "returns error on create room storage failure", ->
      spyOn(store, 'createRoom').andCallFake (name, config, cb) -> cb('failed, yo')
      Room.create 'the-room', {}, (err, result) ->
        expect(err).toEqual('failed, yo')
        expect(result).toBeUndefined()

    it "creates the room", ->
      config = {}
      spyOn(store, 'createRoom').andCallFake (name, cf, cb) ->
        expect(name).toEqual('the-room')
        expect(cf).toBe(config)
        cb(null, true)

      Room.create 'the-room', config, (err, result) ->
        expect(err).toBeNull()
        expect(result).toEqual(true)
helper = require('../../helper')
Room = helper.require('./models/room')
store = helper.require('./store')
queue = helper.require('./queue')

describe 'Room',  ->
  describe 'Room', ->
    beforeEach -> Room.cached = {}

    it "returns error on load room storage failure", ->
      spyOn(store, 'loadRoom').andCallFake (name, cb) -> cb('failed, 2')
      Room.load 'the-room', (err, result) ->
        expect(err).toEqual('failed, 2')
        expect(result).toBeUndefined()

    it "returns null if the room doesn't exist", ->
      spyOn(store, 'loadRoom').andCallFake (name, cb) -> cb(null, null)
      Room.load 'the-room', (err, result) ->
        expect(err).toBeNull()
        expect(result).toBeNull()

    it "returns the room", ->
      spyOn(queue, 'subscribe')
      payload = {conf: {password: 'not-sand'}}
      spyOn(store, 'loadRoom').andCallFake (name, cb) -> 
        expect(name).toEqual('caladan')
        cb(null, payload)

      Room.load 'caladan', (err, room) ->
        expect(err).toBeNull()
        expect(room.name).toEqual('caladan')
        expect(room.config).toBe(payload.conf)

    it "caches the room", ->
      spyOn(queue, 'subscribe')
      payload = {conf: {password: 'not-sand'}}
      spyOn(store, 'loadRoom').andCallFake (name, cb) -> cb(null, payload)
        
      Room.load 'caladan', (err, room) ->
        expect(Room.cached['caladan']).toBe(room)

    it "hooks the room to the queue", ->
      spyOn(queue, 'subscribe')
      spyOn(queue, 'on')
      payload = {conf: {password: 'not-sand'}}
      spyOn(store, 'loadRoom').andCallFake (name, cb) -> cb(null, payload)
        
      Room.load 'caladan', (err, room) ->
        expect(queue.subscribe).toHaveBeenCalledWith('room:caladan')
        expect(queue.on).toHaveBeenCalledWith('room:caladan', room.dispatch)

    it "loads the room from the cache", ->
      Room.cached['earth'] = 'some room'
        
      Room.load 'earth', (err, room) ->
        expect(err).toBeNull()
        expect(room).toEqual('some room')
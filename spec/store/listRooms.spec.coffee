helper = require('../helper')
store = helper.require('./store')

describe 'Store', ->
  describe 'List Rooms', ->
    beforeEach (done) -> helper.storeBeforeEach(done)
    afterEach -> helper.storeAfterEach()

    it "returns error", ->
      spyOn(store.instance, 'smembers').andCallFake (key, cb) -> cb('failure')
      store.listRooms (err, result) ->
        expect(err).toEqual('failure')
        expect(result).toBeUndefined()

    it "returns an empty list", ->
      store.listRooms (err, result) ->
        expect(err).toEqual(null)
        expect(result).toEqual([])

    it "returns the list of rooms", ->
      store.instance.sadd 'room1', 'room2', ->
        store.listRooms (err, result) ->
          expect(err).toEqual(null)
          expect(result).toEqual(['room1', 'room2'])
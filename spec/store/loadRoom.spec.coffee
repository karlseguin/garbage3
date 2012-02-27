helper = require('../helper')
store = helper.require('./store')

describe 'Store', ->
  describe 'Load Room', ->
    beforeEach (done) -> helper.storeBeforeEach(done)
    afterEach -> helper.storeAfterEach()

    it "returns error",  ->
      spyOn(store.instance, 'hget').andCallFake (key, field, cb) -> cb('failure')
      store.loadRoom null, (err, result) ->
        expect(err).toEqual('failure')
        expect(result).toBeUndefined()

    it "returns null if the room doesn't exist", (done) ->
      store.loadRoom 'caladan', (err, data) ->
        expect(err).toBeNull()
        expect(data).toBeNull()
        done()

    it "returns the room", (done) ->
      store.instance.hset 'room:caladan', 'conf', JSON.stringify({password: 'fish'}), ->
        store.loadRoom 'caladan', (err, data) ->
          expect(err).toBeNull()
          expect(data).toEqual({conf: {password: 'fish'}})
          done()
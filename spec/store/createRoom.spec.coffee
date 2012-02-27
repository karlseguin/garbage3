helper = require('../helper')
store = helper.require('./store')

describe 'Store', ->
  describe 'Create Room', ->
    beforeEach (done) -> helper.storeBeforeEach(done)
    afterEach -> helper.storeAfterEach()

    it "returns error", ->
      spyOn(store.instance, 'hsetnx').andCallFake (key, field, value, cb) -> cb('failure')
      store.createRoom null, null, (err, result) ->
        expect(err).toEqual('failure')
        expect(result).toBeUndefined()

    it "creates the room", (done) ->
      store.createRoom 'caladan', {conf: true}, (err, result) ->
        expect(err).toBeNull()
        expect(result).toEqual(true)
        store.instance.hget 'room:caladan', 'conf', (err, result) ->
          expect(JSON.parse(result)).toEqual({conf: true})
          done()

    it "returns false if the room already exists", (done) ->
      store.createRoom 'name', {}, ->
        store.createRoom 'name', null, (err, result) ->
          expect(err).toBeNull()
          expect(result).toEqual(false)
          done()
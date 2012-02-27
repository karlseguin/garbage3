helper = require('../helper')
store = helper.require('./store')
Client = helper.require('./models/client')

describe 'Store', ->
  describe 'Add User To Room', ->
    beforeEach (done) -> helper.storeBeforeEach(done)
    afterEach -> helper.storeAfterEach()

    it "returns error", ->
      spyOn(store.instance, 'sadd').andCallFake (key, value, cb) -> cb('failure')
      store.addUserToRoom 'name', new Client(), (err, result) ->
        expect(err).toEqual('failure')

    it "adds the user to the room", (done) ->
      store.addUserToRoom 'rn1', new Client('a', '2'), (err, result) ->
        expect(err).toBeNull()
        store.instance.smembers 'roomUsers:rn1', (err, users) ->
          expect(users).toEqual(['a|2'])
          done()
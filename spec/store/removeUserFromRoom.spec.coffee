helper = require('../helper')
store = helper.require('./store')
Client = helper.require('./models/client')

describe 'Store', ->
  describe 'Remove User From Room', ->
    beforeEach (done) -> helper.storeBeforeEach(done)
    afterEach -> helper.storeAfterEach()

    it "removes the user from the room", (done) -> 
      store.instance.sadd 'roomUsers:rr1', 'b|z', ->
        store.removeUserFromRoom 'rr1', new Client('b', 'z'), (err, result) ->
        store.instance.smembers 'roomUsers:rr1', (err, users) ->
          expect(users).toEqual([])
          done()
helper = require('../../helper')
Room = helper.require('./models/room')
store = helper.require('./store')

describe 'Room',  ->
  describe 'List', ->
    it "returns the list from the store", ->
      spyOn(store, 'listRooms').andCallFake (cb) -> cb(null, ['a', 'b'])
      Room.list (err, result) ->
        expect(err).toBeNull()
        expect(result).toEqual(['a', 'b'])
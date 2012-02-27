helper = require('../../helper')
Connection = helper.require('./socket/connection')

describe 'Conncetion', ->
  describe 'SendError', ->
    
    it "sends the error payload", ->
      socket = {send: jasmine.createSpy()}
      new Connection(socket).sendError({message: 'this sucks'})
      expect(socket.send).toHaveBeenCalledWith(JSON.stringify({message: 'this sucks', cmd: 'error'}), jasmine.any(Function))
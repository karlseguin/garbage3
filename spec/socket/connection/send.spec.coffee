helper = require('../../helper')
Connection = helper.require('./socket/connection')

describe 'Conncetion', ->
  describe 'Send', ->

    it "sends the payload with the command", ->
      socket = {send: jasmine.createSpy()}
      new Connection(socket).send('test', {cnt: 123, pass: true})
      expect(socket.send).toHaveBeenCalledWith(JSON.stringify({cnt: 123, pass: true, cmd: 'test'}), jasmine.any(Function))
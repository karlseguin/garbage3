helper = require('../../helper')
Client = helper.require('./models/client')
Connection = helper.require('./socket/connection')

describe 'Conncetion', ->
  describe 'Create', ->

    it "creates a connection", ->
      client = new Client(1, 'u')
      socket = {upgradeReq: {_client: client}, on: ->}
      connection = Connection.create(socket)

      expect(connection.socket).toBe(socket)
      expect(connection.client).toBe(client)

    it "hooks events to dispatch", ->
      events = []
      callbacks = []
      onHandler = (e, cb) -> 
        events.push(e)
        callbacks.push(cb)
        
      socket = {upgradeReq: {_client: new Client()}, on: onHandler}
      connection = Connection.create(socket)

      expect(events).toEqual(['message', 'close'])
      expect(callbacks[0]).toBe(connection.dispatch)
      expect(callbacks[1]).toBe(connection.close)
      expect(callbacks.length).toEqual(2)
helper = require('../../helper')
errors = helper.require('./errors')
Client = helper.require('./models/client')
Connection = helper.require('./socket/connection')

describe 'Conncetion', ->
  describe 'dispatch', ->

    it "returns error for invalid data", ->
      socket = {send: jasmine.createSpy()}
      connection = new Connection(socket)
      connection.dispatch 'invalid'
      helper.expectSendWithError(errors.invalidMessage(), socket);

    it "returns error for an unknown command", ->
      data = {"cmd": "unknwon"}
      socket = {send: jasmine.createSpy()}
      connection = new Connection(socket)
      connection.dispatch JSON.stringify(data)
      helper.expectSendWithError(errors.unknownCommand(), socket);

    it "dispatches a join room request", ->
      data = {"cmd": "join", "payload": "blah"}
      connection = new Connection()
      spyOn(connection, 'joinRoom')
      connection.dispatch JSON.stringify(data)
      expect(connection.joinRoom).toHaveBeenCalledWith(data)

    it "dispatches a message request", ->
      data = {"cmd": "mesg", "payload": "bleh"}
      connection = new Connection()
      spyOn(connection, 'sendMessage')
      connection.dispatch JSON.stringify(data)
      expect(connection.sendMessage).toHaveBeenCalledWith(data)  

    it "dispatches a leave room request", ->
      data = {"cmd": "leave", "payload": "bloh"}
      connection = new Connection()
      spyOn(connection, 'leaveRoomByName')
      connection.dispatch JSON.stringify(data)
      expect(connection.leaveRoomByName).toHaveBeenCalledWith(data)    
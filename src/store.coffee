redis = require('redis')

keys =
  room: (name) ->
    "room:" + name
  roomList: ->
    "roomList"
  usersInRoom: (name) ->
    "roomUsers:" + name

class Store
  @instance = null

  @initialize: (config, callback) ->
    @instance = redis.createClient(config.port, config.host)
    @instance.select(config.db, callback)

  @createRoom: (name, config, callback) ->
    # todo improve serialization of config
    multi = @instance.multi()
    multi.hsetnx keys.room(name), 'conf', JSON.stringify(config)
    multi.sadd keys.roomList(), name
    multi.exec (err, result) ->
      return callback(err) if err?
      callback(null, result[0] == 1)

  @loadRoom: (name, callback) ->
    @instance.hget keys.room(name), 'conf', (err, data) ->
      return callback(err, data) if err? || !data?
      callback(null, {conf: JSON.parse(data)})

  @listRooms: (callback) ->
    @instance.smembers keys.roomList(), callback

  @addUserToRoom: (name, client, callback) ->
    @instance.sadd keys.usersInRoom(name), client.key(), callback

  @removeUserFromRoom: (name, client, callback) ->
    @instance.srem keys.usersInRoom(name), client.key(), callback


module.exports = Store
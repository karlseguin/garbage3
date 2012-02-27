redis = require('redis')
EventEmitter = require('events').EventEmitter

class Queue
  @publisher = null 
  @subscriber = null

  @initialize: (config, callback) =>
    @publisher = redis.createClient(config.port, config.host)
    @publisher.select config.db, (err) =>
      return callback(err) if err?
      @subscriber = redis.createClient(config.port, config.host)
      @subscriber.select config.db, (err) =>
        return callback(err) if err?
        @subscriber.on 'message', Queue.dispatch
        callback()

  @subscribe: (channel, handler) =>
    @subscriber.subscribe(channel)

  @publish: (channel, data) =>
    @publisher.publish(channel, JSON.stringify(data))

  @dispatch: (channel, data) =>
    @emit(channel, data)


instance = new EventEmitter()
for key, value of instance
  Queue[key] = value
instance.extended?.apply(Queue)

module.exports = Queue
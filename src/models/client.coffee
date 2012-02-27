crypto = require('crypto')
secret = require('./../config').socket.secret

class Client
  constructor: (@id, @name) ->

  key: ->
    @id + '|' + @name

  @verify: (info, callback) =>
    req = info.req

    token = req.url.split('?')[1]
    return callback(false) unless token?

    #todo remove
    req._client = new Client(token, 'user' + token)
    return callback(true)

    [id, hash] = token.split('-')
    return callback(false) unless id? && hash? && hash == @hmac(id)
    
    req._client = new Client(id, 'user-' + id)
    callback(true)

  @hmac: (id) =>
    hmac = crypto.createHmac('sha1', secret)
    hmac.update(id)
    hmac.digest('hex')

module.exports = Client
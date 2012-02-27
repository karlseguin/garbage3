config = require('./../config')
store = require('./../store')

store.initialize config.store, (err) ->
  if err?
    console.log('store initialization error: %s', err)
    process.exit(1)
  else
    connect = require('connect')
    server = connect()
    server.use(connect.query())
    server.use(connect.bodyParser())
    server.use(connect.router(require('./controller')))
    server.use(connect.static(__dirname + '/playground')) if process.env.NODE_ENV == 'development'
    server.listen(config.manager.port)
    console.log('management server running on port %d', config.manager.port)
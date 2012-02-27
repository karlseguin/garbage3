cluster = require('cluster')
store = require('../src/store')
async = require('async')
cpus = require('os').cpus().length
Client = require('./client')
config = require('./config')

store.initialize config.redis, (err) ->
  quit(err) if err?
  store.instance.flushdb (err) ->
    quit(err) if err?

    functions = []
    for i in [1..config.rooms]
      fn = (id) -> (cb) -> store.createRoom('room' + id, {}, cb)
      functions.push(fn(i))

    async.parallel functions, (err, results) ->
      quit(err) if err?
      store.instance.end()
      start()

quit = (err) ->
  console.log(err)
  process.exit()

start = ->
  if cluster.isMaster
    cluster.fork() for i in [1..cpus]
    cluster.on 'death', (w) ->
      console.log('worker %d died, restarting', w.pid)
      cluster.fork()
    console.log('starting %d workers', cpus)
  else
    launchChild()

launchChild = ->
  for i in [1..config.clients]
    client = new Client(process.pid + '-' + i)
    client.run()

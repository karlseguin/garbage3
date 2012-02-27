source = if /app\.coffee$/.test(process.argv[1]) then './src/' else './lib/'

cluster = require('cluster')
config = require(source + 'config')
cpus = require('os').cpus().length
count = config.processCount


if count == 0
  count = cpus
else if count < 0
  count = cpus - count

if cluster.isMaster
  cluster.fork() for i in [1..count]
  cluster.on 'death', (w) ->
    console.log('worker %d died, restarting', w.pid)
    cluster.fork()
  console.log('starting %d workers', count)
else
  require(source + 'manager/server')
  require(source + 'socket/server')
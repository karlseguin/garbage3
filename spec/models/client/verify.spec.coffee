helper = require('../../helper')
Client = helper.require('./models/client')
store = helper.require('./store')

describe 'Client',  ->
  describe 'Client', ->
    it "returns false if no token is present", ->
      Client.verify {req:{url:'http://dune.gov'}}, (result) ->
        expect(result).toEqual(false)

    it "returns false if token isn't in two parts", ->
      Client.verify {req:{url:'http://dune.gov?justanid'}}, (result) ->
        expect(result).toEqual(false)

    it "returns false if token insn't valid", ->
      Client.verify {req:{url:'http://dune.gov?id-hmac'}}, (result) ->
        expect(result).toEqual(false)

    it "returns true if the token is valid and sets the client context", ->
      info = {req: {url:'http://dune.gov?123232-7e75c49643c4e2c8786d3085d768f8d0f454cace', client: {}}}
      Client.verify info, (result) ->
        expect(result).toEqual(true)
        expect(info.req._client.id).toEqual('123232')
        expect(info.req._client.name).toEqual('user-123232')
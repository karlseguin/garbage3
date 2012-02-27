module.exports =

  generic: (err) ->
    {message: 'an error has occurred, please try again', _inner: err}

  invalidMessage: ->
    {message: 'invalid data'}

  unknownCommand: ->
    {message: 'the command is not known'}

  roomDoesNotExist: ->
    {message: 'the room does not exist'}

  notInRoom: ->
    {message: 'must be in the room to send a message'}

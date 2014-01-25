class window.Stream

  constructor: (url, accumulator) ->
    @url = url
    @accumulator = accumulator
    @websocket = null
    @readCount = 0

  read: (data) =>
    return unless @websocket
    @readCount += 1

    console.log(data)
    @accumulator.append(JSON.parse(data.data))

  resetCount: ->
    @readCount = 0

  connect: ->
    @websocket = new WebSocket(@url)
    @websocket.onmessage = @read

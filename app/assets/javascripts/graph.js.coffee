$ ->

  return unless document.getElementById('graph')

  distance = 150
  width = window.innerWidth - distance - 10
  height = window.innerHeight - distance - 10

  window.graph = new GraphData()
  window.stream = new Stream(window.websocket_url, graph)
  window.stream.connect()

  redrawGraph = =>
    svg = d3.select('#graph').attr('height', height).attr('width', width)
    force = d3.layout.force().gravity(0).distance(distance).charge(0).size([width, height])

    node = svg.selectAll('.node').data(graph.serializeNodes()).enter().append('g').attr('class', 'node').call(force.drag)
    link = svg.selectAll('.link').data(graph.serializeLinks()).enter().append('line').attr('stroke', 'black').attr('class', 'link')

    node.append('text').text (d) -> d.name

    force.on 'tick', ->
      link.attr 'x1', (d) -> d.source.x
      link.attr 'y1', (d) -> d.source.y
      link.attr 'x2', (d) -> d.target.x
      link.attr 'y2', (d) -> d.target.y
      link.attr('stroke-width', (d) -> d.value)
      node.attr 'transform', (d) ->
        "translate(#{d.x},#{d.y})"
    force.nodes(graph.serializeNodes()).links(graph.serializeLinks()).start()

  redrawGraph()

  updateCounts = ->
    $("#read-count").html(window.stream.readCount)
    $("#node-count").html(window.graph.nodeCount)
    $("#link-count").html(window.graph.linkCount)

  setInterval ->
    $('#graph').remove()
    $('body').append("<svg id='graph'></svg>")
    redrawGraph()
    updateCounts()
  , 1500

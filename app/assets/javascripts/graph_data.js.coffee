class window.GraphData

  constructor: ->
    @nodes = {}
    @links = {}
    @linkCount = 0
    @nodeCount = 0

  append: (data) ->
    parent = @createNode(data.klass)
    for reference in data.references
      child = @createNode(reference.klass)
      @createLink(parent, child)
    null

  createNode: (klass) ->
    unless @nodes[klass]
      @nodes[klass] = {name: klass, group: @nodeCount}
      @nodeCount += 1
    @nodes[klass]

  createLink: (parent, child) ->
    link_key = "#{parent.name}-#{child.name}"
    link = @links[link_key]
    @linkCount += 1
    if link
      link.value += 1
    else
      @links[link_key] = {source: parent.group, target: child.group, value: 1}

  clear: ->
    @nodes = {}
    @links = {}
    @linkCount = 0
    @nodeCount = 0


  serializeNodes: ->
    _.values(@nodes)

  serializeLinks: ->
    _.values(@links)

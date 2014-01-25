$ ->

  $(document).on 'click', '.clear', (e) ->
    e.preventDefault()
    stream.resetCount()
    graph.clear()

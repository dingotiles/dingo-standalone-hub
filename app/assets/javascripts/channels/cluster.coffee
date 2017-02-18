App.cluster = App.cable.subscriptions.create "ClusterChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    console.log data

  provision: ->
    # Received by Rails' ClusterChannel#provision method
    @perform 'provision'

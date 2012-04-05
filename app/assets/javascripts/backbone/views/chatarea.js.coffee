class Kandan.Views.ChatArea extends Backbone.View

  template: JST['chatarea']
  # className: 'channels'

  # events:
  #   "click .close_channel" : "deleteChannel"
  #   "click .create_channel": "createChannel"

  render: ->
    $('.header .logo').after(@template({channels: @options.channels}))
    $('.close_channel').click(@deleteChannel);
    $('.create_channel').click(@createChannel);
    for channel in @options.channels.models
      view = new Kandan.Views.ChannelPane({channel: channel})
      $(@el).append(view.render().el)
    $(@el).attr('id', 'channels')
    @

  createChannel: (event)->
    console.log("createChannel called", event);
    channelName = prompt("What's the channel name?", "New channel")
    channelName = channelName.replace(/^\s+|\s+$/g, '')
    if channelName
      channel = new Kandan.Models.Channel({name: channelName})
      channel.save({}, {
        success: (model)->
          Kandan.Helpers.Channels.createChannelArea(model)
      })
      console.log "create channel: #{channelName}"

  deleteChannel: (event)->
    channelIndex = $(event.target).parents('li').prevAll().length
    Kandan.Helpers.Channels.deleteChannelByTabIndex(channelIndex) if channelIndex != 0

#= require_self
#= require_tree ../../templates
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views
#= require_tree ./routers
#= require_tree ./helpers

window.Kandan =
  Models:       {}
  Collections:  {}
  Views:        {}
  Routers:      {}
  Helpers:      {}
  Broadcasters: {}
  Data:         {}
  Plugins:      {}

  init: ->
    channels = new Kandan.Collections.Channels()
    channels.fetch({success: ()=>

      chat_area = new Kandan.Views.ChatArea({channels: channels})
      $('.container').html(chat_area.render().el)

      chatbox = new Kandan.Views.Chatbox()
      $('.container').append(chatbox.render().el)
      $('#channels').tabs()

      # TODO move broadcast subscription to a helper
      # TODO change this to use the broadcaster from the settings
      # TODO set as global to debug. remove later.
      # TODO use wildcard channel names
      window.broadcaster = new Kandan.Broadcasters.FayeBroadcaster()
      for channel in channels.models
        window.broadcaster.subscribe "/channels/#{channel.get('id')}"

      $(document).bind 'changeData', (element, name, value)->
        if(name=="active_users")
          callback() for callback in Kandan.Data.ActiveUsers.callbacks.change

      active_users = new Kandan.Collections.ActiveUsers()
      active_users.fetch({
        success: ()->
          # TODO fix because the current user doesnt get the first event
          active_users.add([$(document).data('current_user')])
          $(document).data("active_users", active_users.toJSON())
          Kandan.Plugins.init_all()
          Kandan.Widgets.init_all()
      })

    })


$(document).ready ->
  Kandan.init()

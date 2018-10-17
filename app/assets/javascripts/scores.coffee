# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
App.room = App.cable.subscriptions.create "ScoresChannel",
  received: (data) ->
    $('table tbody').children().remove()
    cnt = 0
    for team in JSON.parse(data['message'])
      cnt++
      console.log "#{team[0]} - #{team[1]}"
      $('table tbody').append("<tr><td>#{cnt}</td><td>#{team[0]}</td><td>#{team[1]}</td></tr>")
    # $('#messages').append data['message']

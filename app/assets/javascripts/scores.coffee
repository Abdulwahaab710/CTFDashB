# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
App.room = App.cable.subscriptions.create "ScoresChannel",
  received: (data) ->
    $('.scoreboard').children().remove()
    cnt = 0
    for team in JSON.parse(data['message'])
      cnt++
      console.log "#{team[0]} - #{team[1]}"
      $('.scoreboard').append("<tr><td>#{cnt}</td><td id='teamname-#{cnt}'></td><td>#{team[1]}</td><td></td></tr>")
      $("#teamname-#{cnt}").text(team[0])
    # $('#messages').append data['message']

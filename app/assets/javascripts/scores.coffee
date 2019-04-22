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

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
App.room = App.cable.subscriptions.create "ScoresChannel",
  received: (data) ->
    $('table#leaderboard tbody').children().remove()
    cnt = 0
    $('.scores').append('<tr><td>Place</td><td>Team name</td><td>Score</td></tr>')
    for team in JSON.parse(data['message'])
      cnt++
      console.log "#{team[0]} - #{team[1]}"
      $('.scores').append($("<tr/>").html([
        $("<td/>").text(cnt),
        $("<td/>").text(team[0]),
        $("<td/>").text(team[1])
      ]))
    # $('#messages').append data['message']


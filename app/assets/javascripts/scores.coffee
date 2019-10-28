
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
App.room = App.cable.subscriptions.create "ScoresChannel",
  received: (data) ->
    $('table#leaderboard tbody').children().remove()
    cnt = 0
    for team in JSON.parse(data['message'])
      cnt++
      $('table#leaderboard tbody').append($("<tr/>").html([
        $("<td/>").text(cnt),
        $("<td/>").text(team[0]),
        $("<td/>").text(team[1])
      ]))

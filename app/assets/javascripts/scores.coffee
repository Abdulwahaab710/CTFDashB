count = 200
defaults = origin: y: 0.7

fire = (particleRatio, opts) ->
  confetti Object.assign({}, defaults, opts, particleCount: Math.floor(count * particleRatio))
  return

App.room = App.cable.subscriptions.create "ScoresChannel",
  received: (data) ->
    $('table#leaderboard tbody').children().remove()
    cnt = 0
    message = JSON.parse(data['message'])
    submission = message.submission

    for _team in message.scoreboard
      cnt++

      index = document.createElement("td")
      index.appendChild(document.createTextNode(cnt))

      teamLink = document.createElement("a")
      teamLink.href = "/teams/#{submission.team.id}"
      teamLink.appendChild(document.createTextNode(_team[0]))

      team = document.createElement("td")
      team.appendChild(teamLink)

      score = document.createElement("td")
      score.appendChild(document.createTextNode(_team[1]))

      row = document.createElement("tr")
      row.appendChild(index)
      row.appendChild(team)
      row.appendChild(score)

      document.querySelector('table#leaderboard tbody').appendChild(row)

    teamLink = document.createElement("a")
    teamLink.target = "_blank"
    teamLink.href = "/teams/#{submission.team.id}"
    teamLink.appendChild(document.createTextNode(submission.team.name))

    team = document.createElement("a")
    team.appendChild(teamLink)

    challengeLink = document.createElement("a")
    challengeLink.target = "_blank"
    challengeLink.href = "/categories/#{submission.category.id}/challenges/#{submission.challenge.id}"
    challengeLink.appendChild(document.createTextNode(submission.challenge.title))

    challenge = document.createElement("a")
    challenge.appendChild(challengeLink)

    timelineElement = document.createElement("span")
    timelineElement.appendChild(team)
    timelineElement.appendChild(document.createTextNode(" solved "))
    timelineElement.appendChild(challenge)

    timestamp = document.createElement("span")
    timestamp.appendChild(document.createTextNode(submission.created_at))

    timeline = document.createElement("li")
    timeline.appendChild(timelineElement)
    timeline.appendChild(timestamp)

    document.querySelector('.timeline').appendChild(timeline)

    if message.confetti_message

      overlay = document.getElementById('overlay')
      overlay.style.display = 'flex'
      overlay.innerText = message.confetti_message

      fire 0.25,
        spread: 26
        zIndex: 100000
        startVelocity: 55
      fire 0.2, spread: 60
      fire 0.35,
        spread: 100
        decay: 0.91
        scalar: 0.8
      fire 0.1,
        spread: 120
        startVelocity: 25
        decay: 0.92
        scalar: 1.2
      fire 0.1,
        spread: 120
        startVelocity: 45
      setTimeout (->
        overlay.style.display = 'none'
        return
      ), 3000


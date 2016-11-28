# Description:
#   Check Alive-Monitoring for Jenkins Slave PC.
#
# Configuration
#   HUBOT_JENKINS_SLAVE_MONITORING_URL: Jenkins-Master URL
#     e.g. 'http://localhost:8080'
#   HUBOT_JENKINS_SLAVE_MONITORING_TARGE: Slave name and notified channel.
#     e.g. '{"(master)": "#general"}'
#
# Commands:
#   hubot alive? - View status list
#
# Notes:
#   require cron npm
#
# Author:
#   miyay

cronJob = require('cron').CronJob

jenkins_url = process.env.HUBOT_JENKINS_SLAVE_MONITORING_URL
targets = JSON.parse process.env.HUBOT_JENKINS_SLAVE_MONITORING_TARGET

module.exports = (robot) ->
  putRoom = (msg, url, channel) ->
    link = "#{jenkins_url}/computer/#{url}"
    request = robot.http("#{link}/api/json").get()
    request (err, res, body) ->
      hash = JSON.parse body
      message = "<#{link}|#{url}> is #{if hash['offline'] then 'Offline :volcano:' else 'Online :bulb:'}"

      data =
        content:
          pretext: message
          fallback: message
        channel: msg.envelope.room
        username: robot.name
        icon_emoji: ":#{robot.name}:"
      robot.emit "slack.attachment", data

  putCron = (robot, url, channel) ->
    link = "#{jenkins_url}/computer/#{url}"
    request = robot.http("#{link}/api/json").get()
    request (err, res, body) ->
      hash = JSON.parse body
      if hash['offline'] == true
        message = "<#{link}|#{url}> is Offline !!! :volcano:"

        data =
          content:
            pretext: message
            fallback: message
          channel: channel
          username: robot.name
          icon_emoji: ":#{robot.name}:"
        robot.emit "slack.attachment", data

  robot.respond /alive\?/i, (msg) ->
    for url, channel of targets
      putRoom(msg, url, channel)

  # *(sec) *(min) *(hour) *(day) *(month) *(day of the week)
  cronJenkinsSlave = new cronJob('0 */5 * * * *', () =>
    for url, channel of targets
      putCron(robot, url, channel)
  )
  cronJenkinsSlave.start()


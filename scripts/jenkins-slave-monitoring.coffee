# Description:
#   Check Alive-Monitoring for Jenkins Slave PC.
#
# Commands:
#   hubot alive? - View status
#
# Notes:
#   require cron npm
#
# Author:
#   miyay

cronJob = require('cron').CronJob

jenkins_url = ""
targets = {
  # "targetUrl": "noticeChannel"
}

module.exports = (robot) ->
  putRoom = (msg, url, channel) ->
    request = robot.http("#{jenkins_url}/computer/#{url}/api/json").get()
    request (err, res, body) ->
      hash = JSON.parse body
      msg.send "#{url} is #{if hash['offline'] then 'Offline :zzz:' else 'Online :bulb:'}"

  putCron = (robot, url, channel) ->
    request = robot.http("#{jenkins_url}/computer/#{url}/api/json").get()
    request (err, res, body) ->
      hash = JSON.parse body
      if hash['offline'] == true
        robot.send {room: channel}, ":volcano: #{url} is Offline !!!"

  robot.respond /^alive\?$/, (msg) ->
    for url, channel of targets
      putRoom(msg, url, channel)

  # *(sec) *(min) *(hour) *(day) *(month) *(day of the week)
  cronJenkinsSlave = new cronJob('0 */5 * * * *', () =>
    for url, channel of targets
      putCron(robot, url, channel)
  )
  cronJenkinsSlave.start()


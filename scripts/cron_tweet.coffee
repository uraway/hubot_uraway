CronJob = require('cron').CronJob

taskA = ->
  console.log 'task A'
  robot.send 'task A'

job = new CronJob(
  cronTime: "00 30 * * * *"
  onTick: ->
    taskA()
  start: false
)

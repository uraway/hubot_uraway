cronJob = require('cron').CronJob

module.exports = (robot) ->
    cronjob = new cronJob(
        cronTime: "00,10,20,30,40,50 * * * * *"
        start:    true
        timeZone: "Asia/Tokyo"
        onTick: ->
            d = new Date
            min = d.getMinutes()
            sec = d.getSeconds()
            message = "#{sec}secなう！"
            robot.send {user:{user:'uraway_'},screen_name:'uraway_', room: 'Twitter'}, "#{sec}秒なう！"
    )

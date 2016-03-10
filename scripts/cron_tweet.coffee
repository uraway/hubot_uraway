cronJob = require('cron').CronJob
zaif = require('zaif.jp')
api = zaif.PublicApi

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
        robot.send {user:{user:'uraway'},screen_name:'XXXXX', room: 'Twitter'}, "#{sec}秒なう！"
        api.lastPrice('bit_jpy')
          .then(res) ->
            robot.send {room: 'Twitter'}, "last price: #{res}"
          .catch(e) ->
            robot.send {room: 'Twitter'}, "ERROR: #{e}"
    )

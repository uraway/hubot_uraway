cronJob = require('cron').CronJob
zaif = require('zaif.jp')
api = zaif.PublicApi

module.exports = (robot) ->
    cronjob = new cronJob(
        cronTime: "00 * * * * *"
        start:    true
        timeZone: "Asia/Tokyo"
        onTick: ->
          api.lastPrice('bit_jpy').then(res) ->
            robot.send {room: 'Twitter'}, "last price: #{res}"
    )

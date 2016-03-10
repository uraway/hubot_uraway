cronJob = require('cron').CronJob
zaif = require('zaif.jp')
api = zaif.PublicApi
moment = require('moment')

module.exports = (robot) ->
    cronjob = new cronJob(
        cronTime: "0 30 * * * *"
        start:    true
        timeZone: "Asia/Tokyo"
        onTick: ->
            d = new Date
            year = d.getFullYear()
            date = d.getDate()
            hour = d.
            min = d.getMinutes()

            api.lastPrice('btc_jpy')
              .then (res) ->
                robot.send {room: 'Twitter'}, "#{moment().calendar()} last price: #{res.last_price}"
              .catch (e) ->
                robot.send {room: 'Twitter'}, "ERROR: #{e}"
    )

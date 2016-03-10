cronJob = require('cron').CronJob
zaif = require('zaif.jp')
publicApi = zaif.PublicApi
moment = require('moment')

module.exports = (robot) ->
  cronjob = new cronJob(
    cronTime: "00 * * * * *"
    start:    true
    timeZone: "Asia/Tokyo"
    onTick: ->
      publicApi.lastPrice('btc_jpy')
        .then (res) ->
          robot.send {room: 'Twitter'}, "#{res.last_price} #{moment().calendar()}"
        .catch (e) ->
          robot.send {room: 'Twitter'}, "ERROR: #{e}"
  )

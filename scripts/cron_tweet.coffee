cronJob = require('cron').CronJob
zaif = require('zaif.jp')
publicApi = zaif.PublicApi
moment = require('moment')

module.exports = (robot) ->
  cronjob = new cronJob(
    cronTime: "00 00,10,20,30,40,50 * * * *"
    start:    true
    timeZone: "Asia/Tokyo"
    onTick: ->
      publicApi.lastPrice('btc_jpy')
        .then (res) ->
          robot.send {room: 'Twitter'}, "1 BTC = #{res.last_price} JPY"
        .catch (e) ->
          robot.send {room: 'Twitter'}, "ERROR: #{e}"
  )

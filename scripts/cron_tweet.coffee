cronJob = require('cron').CronJob
MarkovChain = require('markov-chain-kuromoji')

Twit = require 'twit'
client = new Twit({
  consumer_key: process.env.HUBOT_TWITTER_KEY
  consumer_secret: process.env.HUBOT_TWITTER_SECRET
  access_token: process.env.HUBOT_TWITTER_TOKEN
  access_token_secret: process.env.HUBOT_TWITTER_TOKEN_SECRET
})

module.exports = (robot) ->
  cronjob = new cronJob(
    cronTime: "00 00,10,20,30,40,50 * * * * *"
    start:    true
    timeZone: "Asia/Tokyo"
    onTick: ->
      client.get 'statuses/home_timeline', {count: 200}, (err, tweets, response) =>
        if !err
          input = null
          for i in tweets
            input += "#{i.text}。"
          input = input.replace /(https?:\/\/[\x21-\x7e]+)/g, ''
          input = input.replace /(@[\x21-\x7e]+)/g, ''
          input = input.replace /\s*/g, ''
          console.log(input)
          markov = new MarkovChain(input)
          markov.start(1, (output) =>
            robot.send {room:'Twitter'}, "#{output}"
            console.log(output);
          )
        else
          console.log err

  )

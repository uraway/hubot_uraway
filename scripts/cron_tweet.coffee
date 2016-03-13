cronJob = require('cron').CronJob
kuromoji = require 'kuromoji'

Twit = require 'twit'
client = new Twit({
  consumer_key: process.env.HUBOT_TWITTER_KEY
  consumer_secret: process.env.HUBOT_TWITTER_SECRET
  access_token: process.env.HUBOT_TWITTER_TOKEN
  access_token_secret: process.env.HUBOT_TWITTER_TOKEN_SECRET
})

items = null

module.exports = (robot) ->
  cronjob = new cronJob(
    cronTime: "00,10,20,30,40,50 * * * * *"
    start:    true
    timeZone: "Asia/Tokyo"
    onTick: ->
      kuromoji.builder({ dicPath: 'node_modules/kuromoji/dist/dict/' }).build (err, tokenizer) ->
        path = tokenizer.tokenize("すもももももももものうち")
        console.log path
      ###
      markov = null
      client.get 'statuses/home_timeline', {count: 200}, (err, tweets, response) =>
        if !err
          input = null
          for i in tweets
            input += "#{i.text}。"
          input = input.replace /(https?:\/\/[\x21-\x7e]+)/g, ''
          input = input.replace /(@[\x21-\x7e]+)/g, ''
          items += input
          markov = new MarkovChain(items)
          markov.start(5, (output) =>
            robot.send {room:'Twitter'}, "#{output}"
            console.log output
          )
        else
          console.log err
        ###
  )

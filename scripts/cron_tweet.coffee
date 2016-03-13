cronJob = require('cron').CronJob
kuromoji = require 'kuromoji'

class MarkovChain
  constructor: (text) ->
    @text = text
    @result = null
    @dictionary = {}
    @output = "output"

  start: (sentence, callback) ->
    @parse(sentence, callback)

  parse: (sentence, callback) ->
    kuromoji.builder({ dicPath: "node_modules/kuromoji/dist/dic/" }).build (err, tokenizer) ->
      path = tokenizer.tokenize @text
      @dictionary = @makeDic path
      @makeSentence @dictionary, sentence
      callback @output

  makeDic: (items) ->
    tmp = ['@']
    dic = {}
    for i of items
      t = items[i]
      word = t.surface_form
      word = word.replace(/\s*/, "")
      if word == "" or word == "EOS"
        continue
      tmp.push word
      if tmp.length < 3
        tmp.splice 0, 1
      @setWord3 dic, tmp
      if word == "。"
        tmp = ['@']
        continue

    return dic

setWord3 = (p, s3) ->
  w1 = s3[0]
  w2 = s3[1]
  w3 = s3[2]
  if p[w1] == undefined
    p[w1] = {}
  if p[w1][w2] == undefined
    p[w1][w2] = {}
  if p[w1][w2][w3] == undefined
    p[w1][w2][w3] = 0
  p[w1][w2][w3]++
  return

makeSentence = (dic, sentence) ->
  i = 0
  while i < sentence
    ret = []
    top = dic['@']
    if !top
      i++
      continue
    w1 = @choiceWord(top)
    w2 = @choiceWord(top[w1])
    ret.push w1
    ret.push w2
    loop
      w3 = @choiceWord(dic[w1][w2])
      ret.push w3
      if w3 == '。'
        break
      w1 = w2
      w2 = w3
    @output = ret.join('')
    return @output
    i++
  return

objKeys = (obj) ->
  r = []
  for i of obj
    r.push i
  r

choiceWord = (obj) ->
  ks = @objKeys(obj)
  i = @rnd(ks.length)
  ks[i]

rnd = (num) ->
  Math.floor Math.random() * num


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
      markov = new MarkovChain("すもももももももものうち")
      markov.start 3, (output) ->
        console.log output
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

ビットコインbotを作る

基本方針

- Herokuにデプロイ(無料枠だと24時間のうち6時間スリープする)
- リプライに返信する
- 定期的にツイートする

こんな感じのbotを作ります。

## Hubotジェネレーター

npmでインストールします。
```
$ npm install -g generator-hubot
```

Hubotの雛形を作成。
```
$ yo hubot
? Owner:
? Bot name:
? Description:
? Bot adapter: twitter
```

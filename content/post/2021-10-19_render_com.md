+++
date = "2021-10-19T21:33:59+09:00"
draft = false
title = "render.comのここがよい"
slug = "render_com"
tags = ["render_com","rails","heroku"]
# image = "defimg/1.jpg"
image = "images/render.png"
+++

<!--more-->

## render.com試してみた

最近、Next.jsアプリと、そのバックエンドAPIとしてrailsアプリを動かすのに、render.comを使ってみました。

自分の中ではherokuが定番なんですが、herokuは最近、個人的に嫌な感情になったことがあったので(詳細略)、前々から試したかったrenderを使ってみたという経緯です。

断っておきますが、herokuはrailsとか動かすのに未だに素晴らしい環境だと思います。特にオートスケーリングと[heroku redis](https://jp.heroku.com/redis)がいいですよね。

——

## render.comのここがよかった

### •ダッシュボード

まず、ダッシュボードがわかりやすいです。

<img alt="render-dashboard" src="/images/render-dashboard.png">

heroku使ったことある人なら、この画面を見れば自分が次に何をすればいいかわかると思います。

**また、ダッシュボード自体のレスポンス速度がすごくよい(ようにみえる)のが良いです。**

**これ一番herokuより優れてる点かも 🚀**

### •Environments Group

<img alt="render-dashboard-2" src="/images/render-dashboard-2.png">

環境変数のリストをグループ化し、serviceとn:nで関連付けることができます。

herokuの場合はwebとworkerを同じappで動かすため、環境変数のリストを共有するということになるのですが、

render.comの場合はwebとworkerを別々のアプリで動かすイメージになるため(たぶん見た感じそうするしかなさそう)、代わりに環境変数のリストをserviceとn:nで紐付けることができるようになっているのだと思います。


## render.comのここが面白かった

### •YAML

左のメニューに「YAML」っていうのがあり、冷静に考えると **「YAMLってなんだよ」** って思うんですが、

ファイル名でルートディレクトリに`render.yaml`という設定ファイルを置くと、そのとおりにserviceが立ち上がってくれるという代物のようです。

herokuの app.json みたいなやつだと思います。 redisの例 -&gt; https://github.com/render-examples/redis/blob/2b068318a10d337c7220cb4ebcfef8ef66379ef0/render.yaml

-----

以下その他の雑感です。

## その他、render.comのここがよかった

* Postgresがネットワーク的に閉じている
    * herokuはこうなっていない
* redisもネットワーク的に閉じている
    * herokuはこうなっていない
* docker対応

## render.comのここがよさそう

* static siteのデプロイにも対応していて、CDNもある
    * でもこれvercelとかnetlifyでいいのでは

## render.comの、これからに期待な点

* [DBのHigh Availabilityがない](https://feedback.render.com/features/p/high-availability-for-postgresql)
* お値段
    * そんなに安くはありません。
    * Next.js, Rails, Postgres, Redisを3週間ぐらい動かして以下の通り

<img alt="render-dashboard-3" src="/images/render-dashboard-3.png">


<script type="text/javascript" src="/js/prism.js" async></script>

以上

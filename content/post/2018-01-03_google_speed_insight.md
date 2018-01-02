+++
date = "2018-01-03T01:33:17+09:00"
draft = false
title = "このサイトを速くした💯"
slug = "google_speed_insight"
tags = ["google_speed_insight","blog"]
image = "images/speed_train.jpg"

+++

### やったこと

キャッシュが効いてないと画像めっちゃ遅い時があるので、いじった。

以下のことをやったら google speed insightで35点 -> 90点台になった。

<!--more-->

* 今までサボっていた画像圧縮
  * tinyPNGとjpegoptim使うようにする(手動)
* CSSの遅延読み込み
  * https://github.com/hoshinotsuyoshi/hugo-theme-casper/commit/99c9dae36eb4de94ab7e6ecfa54e1bbdfb030384
* CSSの一部インライン化
  * これ結構ひどい
  * https://github.com/hoshinotsuyoshi/hugo-theme-casper/commit/3a70d2ea24d5ea55f3216d5d041c904e058f2387
* cloudflareの設定でキャッシュの有効期限をmax(1年)にする
* cloudflareの設定でjs/cssの圧縮配信
　
<img alt="slack" src="/images/google_speed_insight.png" width=800>

### 「CSSの遅延読み込み」について

google様の言うとおりにやってみた

https://developers.google.com/speed/docs/insights/OptimizeCSSDelivery#example

得点を上げるにはこんなことが必要なのか。


### 今後の展望

サーバーの応答時間はcloudflare頼みなので今のところどうにもならん。

一回cloudfront試すか、cloudflareの有料プランやってみてもいいかも!?

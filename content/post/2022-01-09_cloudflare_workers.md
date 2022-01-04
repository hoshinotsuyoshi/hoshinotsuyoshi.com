+++
date = "2022-01-09T17:39:20+09:00"
draft = false
title = "Cloudflare Workersは同じドメインで複数のワーカーを動かしてremixアプリと他アプリを混在させたりできる"
slug = "cloudflare_workers"
tags = ["cloudflare","cloudflare_workers"]
image = "defimg/4.jpg"
+++


便利と思ったのでメモ。

<!--more-->

Cloudflare Workers は ルート設定を工夫することで同じドメインで別々のWorkerを動かすことができます。そのことについてCloudflareの画面のキャプチャを貼りながら説明します。

### subdomain

まず最初に「subdomain」について。

workerが動くsubdomainを決めます。

`*.hoshinotsuyoshi.workers.dev`の `hoshinotsuyoshi`の部分を決めます。

(これはAccountと1:1で紐づくようです。
が、名前が空いていればいつでもリネームできるようです。)

<img alt="worker" src="/images/worker_1.png" width=600>

↑「1つのサービス」の部分はwranglerでpublishすると現れます。

サービスの名前が`awesome` の場合は さきほどのサブドメインと合わせて `awesome.hoshinotsuyoshi.workers.dev` という名前でアクセスできるようになります。

サービスの中に複数の環境(`production`など)を持つことができます。

### WebsiteのDNS設定

実際に独自ドメイン設定をする必要があります。

ここが一番ハマったポイントなんですが、結論としては、以下の3つの方法のどれでもいいっぽい(!)です

https://developers.cloudflare.com/workers/platform/routes

1. CNAMEレコードを作る
    * 値は いずれか1つのWorkerのルート(例: `awesome.hoshinotsuyoshi.worker.dev` )の値
2. Aレコード
    * 値は `192.0.2.1` (RFC5737に定義されたどこにもルーティングされない文書用のアドレス)
3. AAAAレコード
    * 値は `100::` (RFC6666で定義された `reserved IPv6 discard prefix`)

<img alt="cloudflare WebsiteのDNS設定" src="/images/cloudflare_dns_worker.png" width=300>

### Websites と Workers の紐付け

本題です。

「Websites」とは、ドメインのことです。

AWSでいうところのRoute53のzoneのようなイメージです。

Websites(HTTPルート)とサービス(Worker)を紐付けることができます。

<img alt="worker" src="/images/worker_3.png" width=600>

ここが便利だと思ったポイントなのですが、

割り当てるworkerは **ドメイン名ベースではなくURLベースで設定することができます。**

<img alt="worker" src="/images/worker_2.png" width=300>


### 嬉しいこと

つまり、URLのパターンとサービス(Worker)を N:Nで割り当てることができます。


例えば

* remixで書いたUI
* 素のjsで書いたWorker

を 同じドメインで共存させることができます!

具体的には以下のようなことができることを確認しました。

* `awesome.hoshinotsuyoshi.com/assets/*`
    * 素のJSで書いたワーカーAが捌く
* `awesome.hoshinotsuyoshi.com/contents/*`
    * 素のJSで書いたワーカーAが捌く
        * remixアプリのCookie設定と同じことを書けばログイン状態を判別可能
        * ログイン後でないと見れないコンテンツをここで出したりできる
* `awesome.hoshinotsuyoshi.com/*`
    * remixで動くワーカーBが捌く
        * ログイン画面出したりはここでやったりできる


### Routeの注意点

一点Route周りで重要な注意点があり、

[Known issues](https://developers.cloudflare.com/workers/platform/known-issues) に書いてあるのですが、

以下のようにA,Bのようなルートを設定したとき、

```
// (A) example.com/images/*
// (B) example.com/images*

"example.com/images"
// -> B
"example.com/images123"
// -> B
"example.com/images/hello"
// -> B
```

一番最後の "example.com/images/hello" は
普通はAにマッチしそうですが、**この場合はBにマッチしてしまう**そうです😠。

末尾のスラッシュの扱い等に注意が必要そうです。

<script type="text/javascript" src="/js/prism.js" async></script>

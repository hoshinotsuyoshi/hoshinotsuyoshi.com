+++
date = "2017-05-06T17:38:00+09:00"
draft = false
title = "このブログはGithub PagesとCloudflareを利用し独自ドメインでhttps配信しています(ﾉ´∀｀*)の件"
slug = "this-blog-https-apex-record-gh-pages-cloudflare"
tags = ["blog","github-pages","cloudflare"]
image = "images/gh-pages.png"

+++

このブログはGithub PagesとCloudflareを利用し独自ドメインでhttps配信しています(ﾉ´∀｀*)

別件でcloudflareいじってて、どう設定したのか思い出したので、メモを残しておく。

<!--more-->

## cloudflare側

https://www.cloudflare.com/a/add-site に行き、

`hoshinotsuyoshi.com` と入力。

<img alt="slack" src="/images/cloudflare-2.png" width=600>

費用は抑えたいので `Free Website` を選択。

<img alt="slack" src="/images/cloudflare-3.png" width=600>

今のネームサーバの設定についての指示が出ます。

`hoshinotsuyoshi.com` はお名前.comで購入したので、ここではお名前.comのネームサーバが左側に表示されています。

右側に表示されたネームサーバ名2つをメモします。

<img alt="slack" src="/images/cloudflare-4.png" width=600>

## お名前.com側

このネームサーバ2つをお名前.comのほうに反映させます。

<img alt="slack" src="/images/onamae-1.png" width=600>

<img alt="slack" src="/images/onamae-2.png" width=600>

これで `hoshinotsuyoshi.com` のDNSの設定はcloudflareに丸投げ、という形になりました。

## apex domains

ここから先は [github pagesのapex domainsの説明](https://help.github.com/articles/setting-up-an-apex-domain/)
を見れば大丈夫です。

#### リポジトリ側の調整

CNAMEというファイルを用意しておきます。

#### cloudflare側

今回は[Aレコードを登録する方法](https://help.github.com/articles/setting-up-an-apex-domain/#configuring-a-records-with-your-dns-provider)
をやりました。

こちらに書いてあるとおり、

```
192.30.252.153
192.30.252.154
```

の2つのAレコードを登録しておけばOk。

あと、 httpsの設定は `flexible` にしておく。無料利用の場合、この設定じゃないとダメなはず。

## まとめ

こんな感じになってれば設定完了です! 🎉

<img alt="slack" src="/images/gh-pages-cert.png" width=600>
<script type="text/javascript" src="/js/prism.js" async></script>

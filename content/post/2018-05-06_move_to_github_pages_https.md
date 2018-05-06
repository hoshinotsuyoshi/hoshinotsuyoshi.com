+++
date = "2018-05-06T10:54:06+09:00"
draft = false
title = "GitHub Pagesが提供するhttpsに乗り換えてみた(ﾉ´∀｀_)・Cloudflareとスピード比較してみた"
slug = "move_to_github_pages_https"
tags = ["github","github-pages","blog","cloudflare"]
image = "images/lets_encrypt_ssl.png"
+++


[GitHub PagesがカスタムドメインのHTTPSサポートを始めた](https://blog.github.com/2018-05-01-github-pages-custom-domains-https/) ということなので、

乗り換えてみました。

このブログのように、サブドメインなし(zone Apex)で配信していても、問題ないようです。

<!--more-->

今までは [このブログはGithub PagesとCloudflareを利用し独自ドメインでhttps配信しています(ﾉ´∀｀_)の件 · hoshinotsuyoshi.com](https://hoshinotsuyoshi.com/post/this-blog-https-apex-record-gh-pages-cloudflare/) のとおり、Cloudflareを使っていました。

## やったこと

* Aレコードの設定
* Github上のSettingで "Enforce HTTPS"をチェック

### Aレコードの設定

#### before

<img alt="slack" src="/images/cloudflare_setting_before.png" width=600>

#### after

[Github Pagesのヘルプページに書いてあるA record](https://help.github.com/articles/setting-up-an-apex-domain/#configuring-a-records-with-your-dns-provider)(185.199.108.153,185.199.109.153,185.199.110.153,185.199.111.153)を全て設定します。

<img alt="slack" src="/images/cloudflare_setting_after.png" width=600>

オレンジの雲マークのままだと、CloudflareのCDNのIPアドレスがAレコードとして返ってしまうので、この雲をグレーの雲マーク(DNS only)に変更する必要があります。 実はこの設定に気づかなくてハマったのは恥ずかしい。


#### Github上のSettingで "Enforce HTTPS"をチェック

`https://github.com/(リポジトリ名)/settings` で、 「Enforce HTTPS」にチェックします。

<img alt="slack" src="/images/check_enforce_https.png" width=600>


私の場合、正しいAレコードを設定したのにもかかわらず、`Unavailable for your site because your domain is not properly configured to support HTTPS` と表示され、なかなかチェックが可能な状態になりませんでした。

[このforum](https://github.community/t5/Pages/How-to-enable-https-support-on-custom-domains/m-p/6929#M465)に書かれているとおり、カスタムドメイン名を一旦空にしてもう一度入力すると、Aレコードを改めてfetchしてくれるのか、チェックが可能な状態になりました。

### スピード比較してみた

適当なabコマンドで並列数2で数秒試してみました。

#### cloudflare

```sh
Percentage of the requests served within a certain time (ms)
  50%     85
  66%     93
  75%     99
  80%    103
  90%    120
  95%    154
  98%    353
  99%   1092
 100%   1530 (longest request)
```
 
#### github

```sh
Percentage of the requests served within a certain time (ms)
  50%     65
  66%     68
  75%     70
  80%     71
  90%     77
  95%     82
  98%     99
  99%    180
 100%    315 (longest request)
```

中央値ベースでちょっと速くなりました。

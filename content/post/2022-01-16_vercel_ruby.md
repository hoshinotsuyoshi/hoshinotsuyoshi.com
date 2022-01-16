+++
date = "2022-01-16T10:30:10+09:00"
draft = false
title = "vercelでruby動かすときは.vercelignoreでファイル露出を防ぐ"
slug = "vercel_ruby"
tags = ["ruby","vercel"]
image = "defimg/7.jpg"
+++

<!--more-->

### TL;DR

vercelでruby動かすときは `.vercelignore` を設定しないと、意図しないコンテンツがインターネット上に露出してしまうので `.vercelignore` 設定しよう

### コンテンツの露出

こんなかんじのレイアウトでrubyのプロジェクトをvercelにデプロイしてるとき、

```
$ git ls-files
.gitignore
Gemfile
Gemfile.lock
LICENSE
README.md
api/index.rb
```

なんと普通に**http(s)越しに `/Gemfile`とか`Gemfile.lock` が読めてしまう。** こんなかんじ:

```
# Gemfile.lockが見えちゃう例

$ curl -is https://<my vercel app name>.vercel.app/Gemfile.lock
HTTP/1.1 200 OK
(..snip..)
content-disposition: inline; filename="Gemfile.lock"
(..snip..)

GEM
  remote: https://rubygems.org/
  specs:
    cowsay (0.3.0)

PLATFORMS
  ruby

DEPENDENCIES
  cowsay (~> 0.3.0)

BUNDLED WITH
   2.1.4
```

Next.jsとかを動かしてる場合は、もちろんこういうことは起きない。

pythonでもたぶん同じだと思う(試してないけど)。


### `.vercelignore` を設定しよう

[.vercelignore](https://vercel.com/guides/prevent-uploading-sourcepaths-with-vercelignore) という仕組みがあるのでこれを設定する必要がある。

露出させたくないファイル名・ディレクトリ名を列挙するだけ。

`.gitignore` みたいに 先頭に `!` をつけることにより allowlist的な運用ができる。

自分は以下のように設定した。


```
/*
!api
!assets
```

これにより、「基本的に全部非公開」「api と assets は必ず公開」

というようにできる。

**というかこれデフォルト公開で誰か嬉しい人いるの...?**


### ちなみに: `Directory Listing` という機能もある(デフォルトOFF)

[Directory Listing](https://vercel.com/docs/concepts/edge-network/directory-listing) という機能もある。

これはさすがにデフォルトOFFになっていて、

インデックスファイルがない場合にディレクトリの中身を表示する機能。

<img alt="vercel directory listing" src="/images/vercel-directory-listing.png" width=400>

<script type="text/javascript" src="/js/prism.js" async></script>

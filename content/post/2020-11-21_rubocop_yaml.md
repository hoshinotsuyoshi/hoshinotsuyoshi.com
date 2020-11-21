+++
date = "2020-11-21T21:29:04+09:00"
draft = false
title = ".rubocop.ymlシンプルに、ゆるめにやりたいんじゃ"
slug = "rubocop_yaml"
tags = ["rubocop"]
# image = "images/slack_display.png"
image = "defimg/1.jpg"
+++

<!--more-->

## はじめに

CIで怒ってくるrubocop、たまにしかruby書かない人にとっては「煩わしい!!」 みたいな感想を持たれる印象があるので、最近は極力シンプルなルールにするようにしていっています。

最近rubocopが1.0になったし、このエントリではそれを晒してみます。

ちなみにrubocopのバージョンは1.3.1(最新)で、プロジェクトはrailsアプリの想定です。

## .rubocop.yml

はい:

```yaml
# .rubocop.yml

inherit_from: .rubocop_todo.yml

inherit_mode:
  merge:
    - Exclude

require:
  - rubocop-performance
  - rubocop-rubycw

AllCops:
  DisabledByDefault: true
  Exclude:
    - 'gems/**/*'
  NewCops: enable

Bundler:
  Enabled: true

Gemspec:
  Enabled: true

Lint:
  Enabled: true

Performance:
  Enabled: true

Rubycw:
  Enabled: true

Security:
  Enabled: true
```

## .rubocop_todo.yml

`.rubocop_todo.yml` は、
空なんだけど置いてます。

「(このプロジェクトでは)一時的にCI通すためには `.rubocop_todo.yml` つかっていいっすよ! ゆるくやりましょう!」という意思表明です(?)。

```yaml
# .rubocop_todo.yml
# 中身はないです
```


## ポイントとか

### `DisabledByDefault: true` とは

これ基本のやつ。

デフォルトで全部 `disable` にして、有効にしたいやつだけ `Enable` にする、という設定です。

### `NewCops: enable` とは

`NewCops: enable` にすると`rubocop` のバージョンをアップグレードしたときに新しいCopが自動的に有効になります。

その方が<del>楽しい</del>学びがある・改善点が見つかりやすいので、enableにしておきます。

## サボってるやつ・無視してるやつ・敢えて入れてないやつ

## ❌ `Style/*`

これは設定が多いし、 `Lint/*` と比べて重要度低いものなので、敢えて無視するようにしています。

個人的には好みはあるんだけど、それを設定してしまうと設定ファイルが大きくなってしまうから。

なるべく設定ファイルは小さくしたいという思い。

PRで議論があったら個別で追加すればよい、です。

## ❌ `Metrics/*`

デフォルト値が厳しめだったりするので、オフ。

ストイックな設定するとつらくなりがち、です。

## ❌ `rubocop-rails` gem

これは**本来は有効にしたほうがいい**、**おすすめ** と思ってます。。

けどこれも、細かく設定し出すとキリがなくなってしまい、設定ファイルが大きくなってしまうので、

我慢してオフにしてます。

## 有効にしてるやつ・オススメのやつ

## ✅ `rubocop-performance` gem

パフォーマンスってなかなか気づきづらかったりするし、守りやすいので入れている。

## ✅`rubocop-rubycw` gem

これシンプルで結構オススメ。

`ruby -cw` 相当のことをrubocopでチェックできる。

## ✅`Security/*`

セキュリティの話なので、有効に。

<br>

------

ここからは、ラクするための運用とかtipsの話です。

## その他、運用のポイント

### ✔️  TargetRubyVersionは要らない

.ruby-versionを置いていればTargetRubyVersionは要らない ので、特にライブラリとかを開発しているのでなければ不要です。

参考: https://koic.hatenablog.com/entry/target-ruby-version-of-rubocop

### ✔️  rubocop -a だけでなく rubocop -A もつかおう

最近、 `rubocop -a` がセーフな自動修正、 `rubocop -A` が(挙動が変わってしまうかもしれない)自動修正、というふうになりました。

参考: https://koic.hatenablog.com/entry/rubocop-safe-autocorrect-by-default

オートコレクト使うときはdiffをちゃんとチェックするでしょうから、とりあえず `rubocop -A` 使うといいと思います。

### ✔️  `NewCops: disable` でもいいかもしれない

定期的に `rubocop --enable-pending-cops` を実行するのであれば、`NewCops: disable` でもいいかもしれないです。

そのほうが、dependabot等による 継続的 bundle update 時にシュッとrubocopをアップデートしやすいと思います。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">さいきんのrubocopって、 .rubocop.ymlにはNewCops: disableって書いといてpushごとに回るCIはそれで回して、なんか頻度の低いCIまたはやっていきな人がrubocop --enable-pending-copsを実行する感じなのかな</p>&mdash; Tsuyoshi Hoshino (@hoppiestar) <a href="https://twitter.com/hoppiestar/status/1321433358962810881?ref_src=twsrc%5Etfw">October 28, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

--------

以上です

<script type="text/javascript" src="/js/prism.js" async></script>

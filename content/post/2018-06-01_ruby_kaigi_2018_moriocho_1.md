+++
date = "2018-06-01T01:22:54+09:00"
draft = false
title = "RubyKaigi2018杜王町1日目行ってきました・忘れないうちに感想書く"
slug = "ruby_kaigi_2018_moriocho_1"
tags = ["ruby","rubykaigi","moriocho"]
image = "images/e7.jpg"

+++

RubyKaigi2018杜王町1日目行ってきました・忘れないうちに感想書く

<!--more-->

英語全然わからんかった。誤訳・誤解があっても感想ということでご容赦

[全体スケジュール](http://rubykaigi.org/2018/schedule)

## keynote

* [Keynote - RubyKaigi 2018](http://rubykaigi.org/2018/presentations/yukihiro_matz.html#may31)

<blockquote class="twitter-tweet" data-lang="en"><p lang="und" dir="ltr"><a href="https://t.co/B2Ng5uvWDU">pic.twitter.com/B2Ng5uvWDU</a></p>&mdash; hoshinotsuyoshi (@hoppiestar) <a href="https://twitter.com/hoppiestar/status/1002002290843291649?ref_src=twsrc%5Etfw">May 31, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>


### 内容

いずれYouTubeのリンク貼る

### 感想

* yield_selfじゃなくてthenっていうのは良さそう。正直yield_selfについて自分では使わないなと思ってたけど、たしかにこれなら使うかも。
* 良い名前付けをするとコミュニティの求心力が増す。

## Karafka

* [Karafka - Ruby Framework for Event Driven Architecture - RubyKaigi 2018](http://rubykaigi.org/2018/presentations/maciejmensfeld.html#may31)

### 内容

いずれYouTubeのリンク(ry

### 感想

* kafkaが具体的にどんなものなのか予習しないまま来てしまったが、やはり勉強不足で理解度が上がらず。(申し訳ない気持ち)
* microserviceを扱う。kafkaを使うと
  * -> ロードバランシング、フォールトトレラント、etc. 考えることが多い。
  * 「私達はビジネスロジックに集中したい。」
  * convensionという言葉が複数回出てきた気がする。ある程度お任せのフレームワークがあるとラク
* ConsumerとResponderとRoutingがある
  * (後で調べたんだが)wikiが充実してる -> 例:テストの書き方 https://github.com/karafka/karafka/wiki/Testing
* 処理性能が良い
* これ練習アプリ書くとしたらどんなテーマがいいんだろう?
* [Castle](https://castle.io/) で使われてる。てかこのサービス良さそう

## Stripeの 実用的 型チェックのやつ

* [A practical type system for Ruby at Stripe. - RubyKaigi 2018](http://rubykaigi.org/2018/presentations/DarkDimius.html#may31)

### 内容

いずれYouTube(ry

### 感想

* [sorbet.run](https://sorbet.run/)
* <img alt="sorbet" src="/images/sorbet.png" width=600>
* なんかすげー
* 「実用的」な型システムを自前で作って使ってる
* 実際バグが見つけられて便利らしい
* sorbet(シャーベット)のアイコンが、ホイミスライムみたいでかわいかった

<blockquote class="twitter-tweet" data-lang="en"><p lang="ja" dir="ltr">1日目、stripeのやつが個人的には良かった。<br>「型アノテーションは”今”欲しいの‼️だから書いたの‼️」(意訳) て言ってたのが良かった。 <a href="https://twitter.com/hashtag/rubykaigi?src=hash&amp;ref_src=twsrc%5Etfw">#rubykaigi</a></p>&mdash; hoshinotsuyoshi (@hoppiestar) <a href="https://twitter.com/hoppiestar/status/1002189493842034689?ref_src=twsrc%5Etfw">May 31, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

Stripeはruby使ってるけどrailsは使ってない(だっけ?)らしい

リポジトリも意図的に単一リポジトリで管理しているとのこと

## Rubocopの話

* [All About RuboCop - RubyKaigi 2018](http://rubykaigi.org/2018/presentations/bbatsov.html#may31)

### 内容

いずれ(ry

### 感想

* parser gemのおかげでできることは増えたが、parser gemが最初は成熟してなくて辛かったという話

<blockquote class="twitter-tweet" data-lang="en"><p lang="ja" dir="ltr">rubinius やjrubyをサポートしようとするとripperはつらい。MRIのランタイムと結びつきすぎている  -&gt; parser gem が新たな希望に  <a href="https://twitter.com/hashtag/rubykaigia?src=hash&amp;ref_src=twsrc%5Etfw">#rubykaigia</a></p>&mdash; hoshinotsuyoshi (@hoppiestar) <a href="https://twitter.com/hoppiestar/status/1002068303022444544?ref_src=twsrc%5Etfw">May 31, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

* 知ってる内容も意外と多かった
* rubocop1.0.0になるときにrails copとperformance copを本体から外す
* rubocop1.0.0になるときにデフォルトenableなcopの見直し

rubocopはスタイルについてのcommon senseを置き換えるものではない。コードのconsistencyを保つためのもの。

実は以前[あるcopのauto-correctのPRを送った](https://github.com/rubocop-hq/rubocop/pull/4354)ことがある。
S式とかに馴染みがない私でも、ドキュメント見たり既存の実装みたら一応書けたので、なにか思いついたら1回書いてみるといいかもしれない(このときはレビューコメントが多くなってしまって申し訳ない気持ち)。

## Kibaの話

* [Kiba 2 - Past, present & future of data processing with Ruby - RubyKaigi 2018](http://rubykaigi.org/2018/presentations/thibaut_barrere.html#may31)

### 内容

いずれ(ry

### 感想

<blockquote class="twitter-tweet" data-lang="en"><p lang="ja" dir="ltr">pre_processで必要に応じて複数行に展開して、transformでは1行ずつデータを編集しつつ出力する/しないを制御、 destinationではただ書き出すだけ、という感じか   <a href="https://twitter.com/hashtag/rubykaigib?src=hash&amp;ref_src=twsrc%5Etfw">#rubykaigib</a></p>&mdash; hoshinotsuyoshi (@hoppiestar) <a href="https://twitter.com/hoppiestar/status/1002083618661912576?ref_src=twsrc%5Etfw">May 31, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

* Kiba使ったこと無いんだけど(存在は知っていた)、再利用しやすそうなクラスがたくさんあるっぽいので、使ってみてもいいかもしれない
* いろんなETLを実際に書いた結果、本体はものすごくコンパクトになった、感ある


## Hanamiの話

### 内容

いずれ(ry

### 感想

`dry-*` 界隈全然追えてない、、また予習しないまま来てしまって申し訳ない気持ち。

そういえばtrailblazerの話がぜんぜん出なかった気がする。(出たっけ??)

<blockquote class="twitter-tweet" data-lang="en"><p lang="ja" dir="ltr">メンテナンス性がとにかく大事だからとにかくisolateしろ、hanamiはそのためのフレームワークだ、みたいなところだろうか</p>&mdash; hoshinotsuyoshi (@hoppiestar) <a href="https://twitter.com/hoppiestar/status/1002100109096570880?ref_src=twsrc%5Etfw">May 31, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

DDDの思想が色濃く反映されている。らしい。

https://magazine.rubyist.net/articles/0056/0056-hanami.html

## その他

* LT良かった
* ロビーでMtGしてた人がいた
  * 結構大きい正20面体サイコロ使ってる人がいた
<script type="text/javascript" src="/js/prism.js" async></script>

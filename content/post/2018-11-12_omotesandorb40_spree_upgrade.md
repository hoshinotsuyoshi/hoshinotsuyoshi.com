+++
date = "2018-11-12T09:47:44+09:00"
draft = false
title = "omotesando.rb #40でrails update(spree update)についてのLTをした"
slug = "omotesandorb40_spree_upgrade"
tags = ["ruby","spree","rails","rails update"]
image = "images/whisky-01.png"

+++

「railsアップグレード」がテーマのomotesando.rb 第40回で、「spreeのrails updateの戦いの歴史と github上のPR作成時の工夫」というタイトル(長い)でLTに応募し話してきました。

<!--more-->

<a class="embedly-card" data-card-key="6f257114b6df4413a3f5872a7e143278" data-card-controls="0" data-card-type="article-full" href="https://omotesandorb.connpass.com/event/105365/">表参道.rb #40 〜Railsアップグレード〜 (2018/11/08 19:30〜)</a>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

いつもお菓子が出るのでいつもどおりカントリーマアムを2枚食うつもりのお腹🍪🍪だったのですが。

この日はなんとそこそこの量の食事が!!いい意味で油断していました🍴

<blockquote class="twitter-tweet" data-lang="en"><p lang="ja" dir="ltr">ご飯うれしい！ <a href="https://twitter.com/hashtag/omotesandorb?src=hash&amp;ref_src=twsrc%5Etfw">#omotesandorb</a> <a href="https://t.co/mIU5nqe4ck">pic.twitter.com/mIU5nqe4ck</a></p>&mdash; publichtml (@publichtml) <a href="https://twitter.com/publichtml/status/1060507252665212929?ref_src=twsrc%5Etfw">November 8, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

いっぱい食べてしまった。ハイボールに合う肉が美味しかったです。

あと個人的には懇親会もたくさん喋れてよかった。

## tweetsリンク

当日のtweets です -> [当日の #omotesandorb のtweets](https://twitter.com/search?f=tweets&q=since%3A2018-11-08%20until%3A2018-11-09%20%23omotesandorb&src=typd)

## LTスライド

<!-- このdivがないとspeakerdeck小さくなっちゃう -->
<div style="width:400px;">
<script async class="speakerdeck-embed" data-id="0eb659e6d15b45f88345df351a3923e3" data-ratio="1.33333333333333" src="//speakerdeck.com/assets/embed.js"></script>
</div>

## LT

#### Rails::Engineについて話そうとした

反応を見るとほとんどの人が知ってた ので割愛した。

#### git log -S が便利ということについて話した

[スライドはこのあたり](https://speakerdeck.com/hoshinotsuyoshi/spreefalserails-updatefalsezhan-ifalseli-shi-to-githubshang-falseprzuo-cheng-shi-falsegong-fu?slide=79)。

反応を見ると割とほとんどの人が知らない ということがわかった。これ、話してよかった。

#### 「子PRでCIのなかでspecファイル消しちゃうぜ」

[スライドはこのあたり](https://speakerdeck.com/hoshinotsuyoshi/spreefalserails-updatefalsezhan-ifalseli-shi-to-githubshang-falseprzuo-cheng-shi-falsegong-fu?slide=48)。

これ割と反応が良くて良かった。

Rails::Engine使ってるとdb:migrateとrails:update同時が辛い
->
いつまでたってもテストとおらん
->
最初の子PRではspec/features諦めよう!

という話の流れ。

#### その他

12分ぐらい話したっぽい。たぶんちょっと長かった。

緊張してエキサイトしてしまった🙇

#### 意気込み

rails、アップデートしていこうな!!!!!!!!!!!

<script type="text/javascript" src="/js/prism.js" async></script>

+++
date = "2018-12-08T00:57:21+09:00"
draft = false
title = "omotesando.rb #41で技術的負債についてのLTをした"
slug = "omotesandorb41_fusai"
tags = ["ruby","rails","fusai"]
image = "images/accounting_debt.jpg"

+++

「技術的負債」がテーマのomotesando.rb 第41回で、「「技術的負債」について私から言えること私から言えないこと」というタイトルでLTに応募し話してきました。

<!--more-->

<blockquote class="embedly-card" data-card-key="6f257114b6df4413a3f5872a7e143278" data-card-controls="0" data-card-image="https://connpass-tokyo.s3.amazonaws.com/thumbs/22/a2/22a2ba877506389aa98531595dd9d1f0.png" data-card-type="article-full"><h4><a href="https://omotesandorb.connpass.com/event/111189/">表参道.rb #41 〜技術的負債〜 (2018/12/06 19:30〜)</a></h4><p>内容 表参道.rb は表参道周辺のエンジニアが集まって Ruby の周辺技術に関する何かを行う地域Rubyistコミュニティです。 毎月第一木曜日 に開催しています。 最近はLTが多めです。 # LT大会 * 今回のテーマは技術的負債です。 * 負債に苦しんでるので愚痴を聞いてほしい方、立ち向かって奮闘している方、返済した知見を共有したい方など技術的負債に関するお話を募集します。 * と言いつつテーマに関係ないLTも歓迎です。 * 発表時間の制限はありませんが、5〜10分程度の方が多いです。 * 申し込みの際、可能であればLTのタイトルを教えていただけ...</p></blockquote>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

前回に引き続き今回もLTしてきました。

テーマは技術的負債です。

## LTスライド

とにかく難しい話とか抽象論とか抜きにして、負債っぽいものを見つけたら即行動すればええがな、という話をしました。


<!-- このdivがないとspeakerdeck小さくなっちゃう -->
<div style="width:400px;">
<script async class="speakerdeck-embed" data-id="d7754b8af54048b387a3d1153c6d978c" data-ratio="1.33333333333333" src="//speakerdeck.com/assets/embed.js"></script>
</div>

## tweetsリンク

当日のtweets です -> [当日の #omotesandorb のtweets](https://twitter.com/search?f=tweets&q=since%3A2018-11-08%20until%3A2018-11-09%20%23omotesandorb&src=typd)

なんかまた独りよがりなLTになってしまったような気もするが、気にしないことにします😉

このへんが嬉しかった反応

<blockquote class="twitter-tweet" data-lang="en"><p lang="ja" dir="ltr">使ってないコード消してー！！！！ <a href="https://twitter.com/hashtag/omotesandorb?src=hash&amp;ref_src=twsrc%5Etfw">#omotesandorb</a></p>&mdash; Toshio Maki (@Kirika_K2) <a href="https://twitter.com/Kirika_K2/status/1070649910167461888?ref_src=twsrc%5Etfw">December 6, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="en"><p lang="ja" dir="ltr">イケてる技術のプロダクトが数年で死んでいく中、生き残ってお金稼いでるプロダクトに尊敬しかないですよね 。生き残ってるからこその負債。 <a href="https://twitter.com/hashtag/omotesandorb?src=hash&amp;ref_src=twsrc%5Etfw">#omotesandorb</a></p>&mdash; りほやん (@rllllho) <a href="https://twitter.com/rllllho/status/1070650508430368768?ref_src=twsrc%5Etfw">December 6, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="en"><p lang="ja" dir="ltr">ボーイスカウトルールって感じ  <a href="https://twitter.com/hashtag/omotesandorb?src=hash&amp;ref_src=twsrc%5Etfw">#omotesandorb</a></p>&mdash; はいと (@HaiTo_Linux) <a href="https://twitter.com/HaiTo_Linux/status/1070650756053655552?ref_src=twsrc%5Etfw">December 6, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="en"><p lang="ja" dir="ltr">使ってないコードを消す。使ってないコードを静的解析で見つけるみたいなの出来るんでしたっけ <a href="https://twitter.com/hashtag/omotesandorb?src=hash&amp;ref_src=twsrc%5Etfw">#omotesandorb</a></p>&mdash; v-nikushi (@nikushi_jp) <a href="https://twitter.com/nikushi_jp/status/1070650946164682752?ref_src=twsrc%5Etfw">December 6, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="en"><p lang="ja" dir="ltr">ログを出す、PrintDebugはやっぱ最高だって改めて思うんだよねわかる   <a href="https://twitter.com/hashtag/omotesandorb?src=hash&amp;ref_src=twsrc%5Etfw">#omotesandorb</a></p>&mdash; はいと (@HaiTo_Linux) <a href="https://twitter.com/HaiTo_Linux/status/1070651060497203200?ref_src=twsrc%5Etfw">December 6, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="en"><p lang="ja" dir="ltr">シンプルなやり方はやっぱり安心ですね &gt; ログを仕込む <a href="https://twitter.com/hashtag/omotesandorb?src=hash&amp;ref_src=twsrc%5Etfw">#omotesandorb</a></p>&mdash; moggz (@mogulla3) <a href="https://twitter.com/mogulla3/status/1070651356854157313?ref_src=twsrc%5Etfw">December 6, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="en"><p lang="ja" dir="ltr">前回もおもったけど<a href="https://twitter.com/hoppiestar?ref_src=twsrc%5Etfw">@hoppiestar</a> さんメンタルが強い…！ <a href="https://twitter.com/hashtag/omotesandorb?src=hash&amp;ref_src=twsrc%5Etfw">#omotesandorb</a></p>&mdash; りほやん (@rllllho) <a href="https://twitter.com/rllllho/status/1070651571933868034?ref_src=twsrc%5Etfw">December 6, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="en"><p lang="ja" dir="ltr">有用なtipsがモリモリ出てくる <a href="https://twitter.com/hashtag/omotesandorb?src=hash&amp;ref_src=twsrc%5Etfw">#omotesandorb</a></p>&mdash; moggz (@mogulla3) <a href="https://twitter.com/mogulla3/status/1070651688480960513?ref_src=twsrc%5Etfw">December 6, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="en"><p lang="ja" dir="ltr">やっていくしかない強い <a href="https://twitter.com/hashtag/omotesandorb?src=hash&amp;ref_src=twsrc%5Etfw">#omotesandorb</a></p>&mdash; てんきゅー (@talkto_me) <a href="https://twitter.com/talkto_me/status/1070651930521686018?ref_src=twsrc%5Etfw">December 6, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="en"><p lang="ja" dir="ltr">いい話だった！ <a href="https://twitter.com/hashtag/omotesandorb?src=hash&amp;ref_src=twsrc%5Etfw">#omotesandorb</a></p>&mdash; Toshio Maki (@Kirika_K2) <a href="https://twitter.com/Kirika_K2/status/1070652253202112512?ref_src=twsrc%5Etfw">December 6, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

-----

photograph by [www.flickr.com, Monica PC](https://www.flickr.com/photos/aanikap/3727266367/in/photolist-6Fndre-2b6L5aG-quFS1S-qqzpr2-7YL7QX-mvDgjp-ndBFsE-qhnor8-nuWaUe-now4Ko-9DooMJ-nAb7b8-9C9hih-2JGLp-pA5dcy-6UppKx-oPABvE-pAy6ZG-7BePJD-nwv216-jUhN4R-nB6kzL-nQQE49-np4e1u-9mqSr4-96mcMW-8itfmK-mzJHPp-9V9DQw-7A2a6j-oQgoyY-naeBtK-8NuGDD-kNAMs1-nRBiem-2LguJD-5V7xqt-7CqcUT-fieH62-e72GVX-ccbVxb-7yBCJE-7iQYRG-6wbMJJ-pWe3Nq-ehmXiq-iWPquy-25p8mRn-8fankk-8h1Atr)

<script type="text/javascript" src="/js/prism.js" async></script>

---

{{% pixela_access_counter "hoshinotsuyoshi/graphs/hblog-20181208-1" %}}

+++
date = "2019-04-06T11:06:24+09:00"
draft = false
title = "omotesandorb # 45 に参加した"
slug = "omotesandorb45"
tags = ["ruby","rails"]
image = "defimg/1.jpg"
+++

<!--more-->

## omotesando.rb #45参加した・LTした

<br>

今回もいろいろ多岐にわたるLTで面白かった


資料はこちら

<blockquote class="embedly-card" data-card-key="6f257114b6df4413a3f5872a7e143278" data-card-type="article"><h4><a href="https://omotesandorb.connpass.com/event/125126/presentation/">表参道.rb #45 - 資料一覧 - connpass</a></h4><p>「表参道.rb #45」の資料一覧です</p></blockquote>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

(以下、順不同)

### [Rails アプリケーションで複数認証方式を安全に扱う](https://speakerdeck.com/aiponpa/rails-apurikesiyondefu-shu-ren-zheng-fang-shi-woan-quan-nixi-u)

ラクスルのリファクタリングの話。

リリース直前にリファクタした。
ディレクトリ構成をすっきりしてわかりやすくするようにした。

### [技術選定で失敗した話](https://speakerdeck.com/atomiyama/ji-shu-xuan-ding-deshi-bai-sitahanasi)

(失敗した話、というタイトルだが、深刻な話ではない印象だった)

OpenAPI3.0の話。

swagger-blocks捨ててcommitteeへ

(この辺の話、私そこまで詳しくないので早くキャッチアップが必要だ)

### [RakSulのInternal API開発で gRPCを導入した話](https://www.slideshare.net/nixiesan/raksulinternal-api-grpc)

gRPCの話。

swaggerの話とは逆(?)で、JSON Schemaとの比較・エディタの使いやすさの理由でgRPCを採用した話。

`$ref`は辛いらしい(なんとなくわかる)

(この辺の話、私そこまで詳しくないので早くキャッチアップが必要だ)

### ApplicationModelの話

railsdm2019の [Ruby on Railsの正体と向き合い方 _ What is Ruby on Rails and how to deal with it_ - Speaker Deck](https://speakerdeck.com/yasaichi/what-is-ruby-on-rails-and-how-to-deal-with-it) へのアンサーソング的な話。(引用があったので、とのこと。)

「Ruby on Railsの正体と向き合い方」で語られている言葉だと「コードレベルでのアプローチ」の一種なんだけど、

わりと現時点では最もリーズナブルな手法かなと思った。

懇親会で、「app/modelsに何かPOROを生やすほうがapp/forms app/servicesを生やすよりも抵抗が少ない」みたいな話を誰かと話した。

### [ENGINEER WORK!!](https://www.slideshare.net/sinsoku/engineer-work-139575695)

顧客との交渉の話。

上長や顧客と仕様を決めるときに、どのような案を出すのかという話が面白かった。

### [Ruby にコミットしよう](https://osyo-manga.github.io/slide-omotesandorb-45-ruby_commit/#/)

Time#floor、確かに便利そう。

Time#ceilもあったほうが良いのかも知れないが、ユースケースを募集中とのこと。


### [RailsでViewModel導入に 挫折しかけてる話](https://speakerdeck.com/yaboojp/railsdeviewmodeldao-ru-ni-cuo-zhe-sikaketeruhua-at-biao-can-dao-dot-rb-number-44)

ViewModelの話。

ViewModelを導入するとコントローラーがすっきりした話(試行錯誤中の話)


## 自分のLT

LTの時間を頂いた。

自分は対応した脆弱性周りの話をした。

スライド。 -> https://hoshinotsuyoshi.com/docs/essay20190404/#1

ちなみにスライドは初めてgibierを使った。いつも喋りすぎてしまうので。。

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">今回のスライドのウサギアニメは自作ですかと聞かれたので宣伝すると、自作ではなくて gibierというmarkdownをスライドにするgemです <a href="https://t.co/RVumNERoVI">https://t.co/RVumNERoVI</a></p>&mdash; hoshino tsuyoshi (@hoppiestar) <a href="https://twitter.com/hoppiestar/status/1113811099441176576?ref_src=twsrc%5Etfw">2019年4月4日</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

## セキュリティの話

脆弱性の話をしたことで、懇親会でいろいろ話が聞けてよかった。

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">懇親会でいろいろ話出来て良かった。サービスレベルによってはHTTPリクエストヘッダ保存してたりするところも。 セキュリティの話はみんなアピールしないからなー！ 勉強になる <a href="https://twitter.com/hashtag/omotesandorb?src=hash&amp;ref_src=twsrc%5Etfw">#omotesandorb</a></p>&mdash; hoshino tsuyoshi (@hoppiestar) <a href="https://twitter.com/hoppiestar/status/1113808041252507655?ref_src=twsrc%5Etfw">2019年4月4日</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

## その他感想

自分のところではswagger化はできていないので、OpenAPI3の話は本当にあとで参考になりそうな資料という感じ。良かった。
やっぱりcommittee使うんですね。
上にも書いたけど、キャッチアップせねば。。


<script type="text/javascript" src="/js/prism.js" async></script>

---

{{% pixela_access_counter "hoshinotsuyoshi/graphs/hblog-20190406-1" %}}

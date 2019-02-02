+++
date = "2018-06-02T10:46:26+09:00"
draft = false
title = "RubyKaigi2018杜王町2日目行ってきました・忘れないうちに感想書く"
slug = "ruby_kaigi_2018_moriocho_2"
tags = ["ruby","rubykaigi","moriocho"]
image = "images/sendai_kokusaicenter.JPG"

+++

引き続き英語全然わからんかった。誤訳・誤解があっても感想ということでご容赦♫

<!--more-->

[💎全体スケジュール](http://rubykaigi.org/2018/schedule#jun01)

------

## いきなり関係ない話: 仙台城跡付近を<s>散策</s> 登山した

朝はやく起きたので散歩してきました

散歩のつもりがいつの間にか**登山**してました

#### 五色沼

<img alt="goshikinuma" src="/images/sendai_goshikinuma.JPG" width=600>

#### 坂道

想像の2倍ぐらいの坂だった

<img alt="sakamichi" src="/images/sendai_sakamichi.JPG" width=600>

#### 石垣

<img alt="ishigaki" src="/images/sendai_ishigaki.JPG" width=600>

#### 頂上

仙台市です

<img alt="sendai_city" src="/images/sendai_city.JPG" width=600>

伊達政宗像です

<img alt="masamune" src="/images/masamune.JPG" width=600>


このあと東北大学内のカフェで天津丼食べました。

少し仕事のコードを書いたりして9:40ぐらいから山を降りてきて参加…なんて優雅なんだ…

------

以下、疲れたので軽くメモ程度に。。

## keynote

[My way with Ruby - RubyKaigi 2018](http://rubykaigi.org/2018/presentations/ktou.html#jun01)

### 感想

* 「必要だから作る」
* ポジティブな雰囲気が漂う良いキーノートだった
* 誘い笑いが良かった


------

## 安全にbundle updateする話

[Journey of a complex gem upgrade](http://rubykaigi.org/2018/presentations/Edouard-chin.html#jun01)

### 感想

* フラグ作ってローリングリリースする。5%のサーバだけ新しいGemつかう、とか。

```ruby
if ENV['SHOPIFY_NEXT']
  gem 'rubykaigi', '3,1'
else
  gem 'rubykaigi', '3,0'
end
```

* componentという単位に分けてユニットテストが通るかどうか見てる
  * たぶんすごくモノリシックなリポジトリ
  * スプレッドシートでcomponent単位でテスト通ってるかどうか進捗管理

この方法だとブランチが少なくなりそう



------

## 全部rubyでやる話

[It's Rubies All The Way Down](http://rubykaigi.org/2018/presentations/wyhaines.html#jun01)

### 感想

全部rubyでやったらどうなるかという話だけど、そうか、データベースとか難しいんですね

あとで読み返す




------

## Productivity and Education

[Scaling Teams using Tests for Productivity and Education](http://rubykaigi.org/2018/presentations/jules2689.html#jun01)

### 感想

これ面白かった。<s>別途まとめる</s>

まとめた -> [rubykaigi、shopifyのテストの話が良かった](/post/ruby_kaigi_2018_shopify/)



------

## Rubex

[Ferrari Driven Development superfast Ruby with Rubex](http://rubykaigi.org/2018/presentations/v0dro.html#jun01)

### 感想

自分には難しかった、、

### ✎まとめ

なんか2日目は登山したせいかどっと疲れた。

あと1日楽しみます💎
<script type="text/javascript" src="/js/prism.js" async></script>

---

{{% pixela_access_counter "hoshinotsuyoshi/graphs/hblog-20180602-1" %}}

+++
date = "2017-01-14T11:43:09+09:00"
draft = false
title = "{ prop1, prop2 }みたいなオブジェクト記法(shorthand property names)と文字列リテラルを使わないhello world"
slug = "shorthand_property_names_hello_world"
tags = ["javascript","es2015"]
image = "images/sunshine_2.jpg"

+++

JSの波括弧に感動するシリーズ、第2回です。

なお今回の第2回目で最終回の予定です!!

第1回目はこちら([君はarrow functionの波括弧省略について知っているか](https://hoshinotsuyoshi.com/post/arrow_func_no_brace/))でした。

<!--more-->

### ✎Shorthand property names

最近のオブジェクトは、このように書けるようです。

```javascript
var prop1 = 'a';
var prop2 = 'b';
{ prop1, prop2 } //  {prop1: "a", prop2: "b"}
```

下記↓のページに説明が書いてあります。

<blockquote class="embedly-card" data-card-key="6f257114b6df4413a3f5872a7e143278" data-card-type="article-full"><h4><a href="https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Operators/Object_initializer">オブジェクト初期化子</a></h4><p>オブジェクトは new Object() 、 Object.create() 、 リテラル 表記法 ( initializer 表記法)を使用して初期化されます。オブジェクト初期化子はオブジェクトのプロパティ名と関連した値のゼロ以上のペアのリストです。中括弧( {} )で囲まれます。</p></blockquote>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

`Shorthand property names`て言うんですね、知らなかった。。

#### ✎さて感想

わたしはRubyばかり書くマンなので、これはRubyでいうところの`Set`に似てるなと思いました。

似てないですかね。重複がないのを保証してくれるのが、`Set`に近いと思いました。

#### ✎「文字列リテラルを使わずにhello worldを出力しなさい」というお題

この記法のメリットとしては、まあ実務上もいろいろあると思うんですが、

**実務上じゃない範囲で**考えますと、以下の問題を簡単に解くことができることに気づきました！

`文字列リテラルを使わずにhello worldを出力しなさい`

これは意外と難しくて、例えば、こんな解き方があるみたいです↓。

<blockquote class="embedly-card" data-card-key="6f257114b6df4413a3f5872a7e143278" data-card-type="article"><h4><a href="http://qiita.com/alucky0707/items/6ecb34253c9cb206c53e">JavaScriptで文字列と数値リテラルを使わずにHello World - Qiita</a></h4><p>何を今更、って感じですが書きたくなったので許してください。 元ネタ= https://codeiq.jp/ace/cielavenir/q431 僕が書いたらこんな風になりました。 var zero = +String.prototype, one = -~zero, two = one  one, four = one  two, hundred = ({} + zero).charCodeAt(two) + two; ...</p></blockquote>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

...難しいですね。

### ✎Shorthand property namesを使えば簡単さ。

こうすればいいことに気づいた！！

```javascript
var ハローワールド;
console.log(Object.keys({ハローワールド})[0]); // ハローワールド
```

<br>
<br>
<br>

はい！！！！！！！ 🌃🌃

<br>
<br>

とりあえず手元のChrome55では動作します。 🌠🌠🌠
<script type="text/javascript" src="/js/prism.js" async></script>

---

{{% pixela_access_counter "hoshinotsuyoshi/graphs/hblog-20170113-1" %}}

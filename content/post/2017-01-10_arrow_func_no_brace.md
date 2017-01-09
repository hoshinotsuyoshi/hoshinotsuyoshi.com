+++
date = "2017-01-10T04:12:50+09:00"
draft = false
title = "君はarrow functionの波括弧省略について知っているか"
slug = "arrow_func_no_brace"
tags = ["javascript","es2016"]
image = "images/sunshine_1.jpg"

+++

引き続き勉強兼ねて[chrome拡張書いてる](https://hoshinotsuyoshi.com/post/jobcan_flex_chrome/)んですが、
そのときに読んで知った初心者メモ。

引数の丸括弧`()`の省略については知っていたんですが、波括弧`{}`も省略できる時があるんですね。


<!--more-->

1行だけ・かつ返り値として扱うときにこう書ける。

```javascript
// #1
twice = n => n * 2;
twice(3); // 6
```

\#1は波括弧を省略しているためそのステートメントの結果が返り値になります。

つまり↑の#1は以下#2と等価ではありません。

```javascript
// #2
twice = n => { n * 2; }
twice(3); // undefined
```

\#1は以下#3と等価です。

```javascript
// #3
twice = n => { return n * 2; }
twice(3); // 6
```

<br>
<br>



### さて

オブジェクトリテラルも波括弧(`{`)を使うので、

arrow(`=>`)の**次にオブジェクトリテラルが来ると混乱しそう**ですが、

>
```javascript
// object リテラル式を返す場合は、本体を丸括弧 () で囲みます:
params => ({foo: bar})
```
> [アロー関数 - JavaScript _ MDN](https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/arrow_functions)

とのことです。

<br>

手元のchrome(chrome55)で確認すると、こんな感じでした。

```javascript
bar = 1
func1 = params => ({foo: bar})
func2 = params => {foo: bar}

console.log(func1()); // Object {foo: 1}

console.log(func2()) // undefined
```

なるほど…

+++
date = "2017-01-05T00:50:10+09:00"
draft = false
title = "今月あとどれくらい働けばよいか計算するChrome拡張書いている"
slug = "jobcan_flex_chrome"
tags = ["chrome extension"]
image = "images/sushi.jpg"

+++

n年ぶりにChrome拡張を書いたりしています。経緯について話さなければならない。

<!--more-->

### 経緯を3行で

* **フレックス勤務**のため、1ヶ月トータルで「8時間*営業日数」ぶん働けば良いことになっている。
* 各自、勤務表([ジョブカン](http://jobcan.ne.jp/))とにらめっこし、今月あと何時間働けばよいか計算する必要がある。
* ジョブカンには **WebAPIが無い。**

上記の問題を解決するため、同僚がいい感じに勤務表をスクレイピングするsinatraアプリを書いたのですが、
今回自分は敢えてchrome拡張版を作ろうと思いたちました。

### 今回スクレイピング対象となるページ(勤務表)のふんいき

こんなん。

<img alt="jobcan" src="/images/jobcan.png" width=600>

### 進捗

**40%ぐらいできた**気がする。今のところ私のPCでしか動きません🙏

### ようす

拡張のボタンを押すと、
自分の勤務表のデータが読み込まれ、「今月の残りは1日平均どのくらい働けば良いか」を教えてくれます。

<img alt="extension" src="/images/jobcan_extension_anime.gif">

上記の例は、『今月は残り1日平均8.15時間働けば良い』という計算結果を出力した様子です。

とりあえずバッヂ([chrome.browserAction - Google Chrome](https://developer.chrome.com/extensions/browserAction#badge))で実装してみたが、
バッヂは常時表示する必要あるからウケが悪い気がする。再考の余地あり。

### コード

今のところ部品化もしておらず、テストも無いコードですが。

<blockquote class="embedly-card" data-card-key="6f257114b6df4413a3f5872a7e143278" data-card-type="article"><h4><a href="https://github.com/hoshinotsuyoshi/how-many-work-time-chrome-extension/tree/it-works">hoshinotsuyoshi/how-many-work-time-chrome-extension</a></h4><p>how-many-work-time-chrome-extension - [WIP]今月はあとどれぐらい働けばいいのかな？2</p></blockquote>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>


### 展望

↓このboilerplateが参考になったので、引き続き参考にしつつ部品化とテスト追加をやってみたい。

<blockquote class="embedly-card" data-card-key="6f257114b6df4413a3f5872a7e143278" data-card-type="article"><h4><a href="https://github.com/jhen0409/react-chrome-extension-boilerplate">jhen0409/react-chrome-extension-boilerplate</a></h4><p>react-chrome-extension-boilerplate - Boilerplate for Chrome Extension React.js project</p></blockquote>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

### ✎まとめ

未完🍊です。いつかまとめられたらいいな。

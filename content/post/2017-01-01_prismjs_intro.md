+++
date = "2017-01-01T21:00:00+09:00"
draft = false
title = "このブログのコードのシンタックスハイライトにPrismを利用することにした"
slug = "prismjs_intro"
tags = ["hugo","ghost","casper","blog","javascript"]
image = "images/coy.png"

+++

このブログはcasper([vjeantet/hugo-theme-casper](https://github.com/vjeantet/hugo-theme-casper))というテーマを使っています。

デフォルトではコードを貼り付けたときにシンタックスハイライトが効かないことに気づいたので、CSSやJS周りを調整しました。

<!--more-->

## ✎Prismを使ってみる

Prism([PrismJS/prism](https://github.com/PrismJS/prism))というやつが目に止まりましたのでこれを使ってみます。

[MITライセンス](https://github.com/PrismJS/prism/blob/v1.6.0/LICENSE)です。

まず[http://prismjs.com](http://prismjs.com)に訪問する。こんな↓サイトです。

<img alt="prism" src="/images/prismjs.png" width=400 >

「DOWNLOAD」ボタンを押すとこんな画面です。↓

<img alt="prism_choose" src="/images/prismjs_choose.png" width=400 >

ここで**利用する言語に応じてCSSをカスタマイズすることができます。**

チェックした言語がCSSに反映されるようです。

さらに「DOWNLOAD JS」及び「DOWNLOAD CSS」ボタンを押すと、prism.jsとprism.cssが降ってきます。

## ✎casperに反映させる

どうやらcasperのコードを読むと、cssはheaderに、jsはfooterに貼れば良いっぽいので、
近いところに貼っていきます。

それぞれ差分はこんな感じ。

#### layouts/partials/footer.html

```diff
diff --git a/layouts/partials/footer.html b/layouts/partials/footer.html
index 7a19ad6..4c5f0d1 100644
--- a/layouts/partials/footer.html
+++ b/layouts/partials/footer.html
@@ -7,6 +7,7 @@
     </div>
     <script type="text/javascript" src="{{.Site.BaseURL}}js/jquery.js"></script>
     <script type="text/javascript" src="{{.Site.BaseURL}}js/jquery.fitvids.js"></script>
+    <script type="text/javascript" src="{{.Site.BaseURL}}js/prism.js"></script>
     <script type="text/javascript" src="{{.Site.BaseURL}}js/index.js"></script>
     {{ if .Site.Params.customFooterPartial }}
         {{ partial .Site.Params.customFooterPartial . }}
```

#### layouts/partials/header.html

```diff
diff --git a/layouts/partials/header.html b/layouts/partials/header.html
index d17b5df..6709e1c 100644
--- a/layouts/partials/header.html
+++ b/layouts/partials/header.html
@@ -37,6 +37,7 @@
 
     <link rel="stylesheet" type="text/css" href="{{.Site.BaseURL}}css/screen.css" />
     <link rel="stylesheet" type="text/css" href="{{.Site.BaseURL}}css/nav.css" />
+    <link rel="stylesheet" type="text/css" href="{{.Site.BaseURL}}css/prism.css" />
     <link rel="stylesheet" type="text/css" href="//fonts.googleapis.com/css?family=Merriweather:300,700,700italic,300italic|Open+Sans:700,400|Inconsolata" />
 
 
```

コミットはこちらです。

<blockquote class="embedly-card" data-card-key="6f257114b6df4413a3f5872a7e143278" data-card-type="article"><h4><a href="https://github.com/hoshinotsuyoshi/hugo-theme-casper/commit/e73abaa1dd93313836bc9e07bd68ce21bfd8c420">http://prismjs.com/download.html で取得した jsとcssをセットした · hoshinotsuyoshi/hugo-theme-casper@e73abaa</a></h4><p>Coy tshedor 3.93KB Markup 0.82KB CSS 0.99KB C-like 0.68KB JavaScript 1.3KB Go arnehormann 0.67KB Bash zeitgeist 872.76KB C zeitgeist 870.94KB Ruby samflores 2KB YAML hason 1.14KB Ruby samflore...</p></blockquote>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

## ✎シンタックスハイライトが効いた!


### before↓

<img alt="before" src="/images/highlight_before.png" width=400 >

### after↓

<img alt="after" src="/images/highlight_after.png" width=400 >


## ✎まとめ

シンタックスハイライトを手に入れることができました! 🎉

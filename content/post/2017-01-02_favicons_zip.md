+++
date = "2017-01-02T08:30:00+09:00"
draft = false
title = "realfavicongenerator.netで作ったfaviconをこのブログのcasperのテーマに反映"
slug = "favicons_zip"
tags = ["hugo","ghost","casper","blog","favicon"]
image = "images/downloads_favicons.png"

+++

このブログはcasper([vjeantet/hugo-theme-casper](https://github.com/vjeantet/hugo-theme-casper))というテーマを使っています。
ファビコンが効いてないことに気づいたので、調整しました。
realfavicongenerator.netを使ってみて結構便利だったので紹介します。

<!--more-->

## ✎最終的にはこんな感じでファビコンを効かせたい

<img alt="favicon" src="/images/my_favicon.png" width=400 >

## ✎今回の素材はこちら

<img alt="星野剛志" src="/images/hoshinotsuyoshi.jpg" width=200 >

## ✎realfavicongenerator.netを使ってみる

知らなかったんですが、[こちらの記事](http://itexp.hateblo.jp/entry/website-needs-21-favicons)でも紹介されている`realfavicongenerator.net`は大変便利でした。

<blockquote class="embedly-card" data-card-key="6f257114b6df4413a3f5872a7e143278" data-card-type="article-full"><h4><a href="http://realfavicongenerator.net/">Favicon Generator for all platforms: iOS, Android, PC/Mac...</a></h4><p>The ultimate favicon generator. Design your icons platform per platform and make them look great, everywhere</p></blockquote>
<script async src="//cdn.embedly.com/widgets/platform.js" charset="UTF-8"></script>

realfavicongenerator.netでは、

* 必要なファビコンの生成
    * 色んなサイズが生成され、zipで固まって降ってきます (≧∇≦)b
    * [browserconfig.xml](https://msdn.microsoft.com/en-us/library/dn320426(v=vs.85).aspx)とかいう、Microsoft方面向けのメタデータも入ってくる
* 実際のサイトに対してのファビコンのテスト

ができます。

## ✎realfavicongenerator.netで必要なファビコンの生成

まず右のほうの"Select your favicon picture"を押し、素材をアップロードします。

<img alt="realfavicongenerator" src="/images/favicon_select.png" width=400 >

次の画面で適当にカスタマイズして進んでいくと(私はデフォルトのままにしました)、最後こんな画面になります。

<img alt="realfavicongenerator" src="/images/favicon_select_last.png">

ここで`Favicon package`を押すと`favicons.zip`のダウンロードが始まります。

私の場合`favicons.zip`を展開するとこんな感じでした。

<img alt="realfavicongenerator" src="/images/downloads_favicons.png" width=600 >

## ✎ファビコンをcasperに反映

まず、展開したファイルたち全てをルートディレクトリに配置します。

```bash
$ ls -d ~/Downloads/favicons/* | xargs -I {} mv {} ./static
```

そのときのコミットは[こちら](https://github.com/hoshinotsuyoshi/hoshinotsuyoshi.com/commit/c883c21a17951c47addd2c7d440c7f0e19866dfe)。

次に、realfavicongeneratorが吐いたlinkタグなどのhtmlをheadタグの中に貼ります。

```diff
+    <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
+    <link rel="icon" type="image/png" href="/favicon-32x32.png" sizes="32x32">
+    <link rel="icon" type="image/png" href="/favicon-16x16.png" sizes="16x16">
+    <link rel="manifest" href="/manifest.json">
+    <link rel="mask-icon" href="/safari-pinned-tab.svg" color="#5bbad5">
+    <meta name="theme-color" content="#ffffff">
```

そのときのコミットは[こちら](https://github.com/hoshinotsuyoshi/hugo-theme-casper/compare/e73abaa1dd93313836bc9e07bd68ce21bfd8c420...dcab223a01c10a7bbdf5f4a1a90540da82d70758)

## ✎realfavicongenerator.netでファビコンのテスト

デプロイしたら、テストしてみましょう。

自分のサイトのアドレスを入力して、`Check Favicon`ボタンを押します。

<img alt="realfavicongenerator" src="/images/favicon_test1.png" width=400>

チェックが終わると、こんな感じで結果が表示されます。

<img alt="realfavicongenerator" src="/images/favicon_test2.png">

ぜんぶパスしました🎉 うれしいですね。


## ✎まとめ

* casperをいじっている
* realfavicongenerator.netで、必要なファビコンの生成とファビコンのテストができ、便利でした

<script type="text/javascript" src="/js/prism.js" async></script>

---

{{% pixela_access_counter "hoshinotsuyoshi/graphs/hblog-20170102-1" %}}
